<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<div id="messages-root" class="mt-6">
  <div class="flex h-[calc(100vh-160px)] bg-white rounded-2xl border border-slate-100 shadow-sm overflow-hidden">

    <%-- ===== LEFT: Patient Chat List ===== --%>
    <div class="w-80 lg:w-96 border-r border-slate-100 flex flex-col bg-slate-50/30">

      <%-- Search Bar --%>
      <div class="p-4 bg-white border-b border-slate-100">
        <div class="relative">
          <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-slate-400 text-[18px]">search</span>
          <input type="text" id="chat-search" placeholder="Search patients..."
            class="w-full pl-9 pr-4 py-2 bg-slate-100 border-none rounded-xl text-sm focus:ring-2 focus:ring-brand-blue/20 transition-all" />
        </div>
      </div>

      <%-- Patient List (rendered by JS) --%>
      <div class="flex-1 overflow-y-auto" id="patient-chat-list">
      </div>
    </div>

    <%-- ===== CENTER: Active Chat ===== --%>
    <div class="flex-1 flex flex-col bg-white" id="active-chat-container">

      <%-- Chat Header --%>
      <div class="h-16 border-b border-slate-100 px-6 flex items-center justify-between shrink-0">
        <div class="flex items-center gap-3" id="active-chat-user">
          <%-- Populated by JS --%>
        </div>
        <div class="flex items-center gap-2">
          <button class="p-2 text-slate-400 hover:bg-slate-50 rounded-full transition-colors" title="View Records">
            <span class="material-symbols-outlined">description</span>
          </button>
          <button class="p-2 text-slate-400 hover:bg-slate-50 rounded-full transition-colors" title="Book Appointment">
            <span class="material-symbols-outlined">add_task</span>
          </button>
        </div>
      </div>

      <%-- Chat History --%>
      <div class="flex-1 overflow-y-auto p-6 space-y-4 bg-slate-50/30" id="chat-history">
        <%-- Populated by JS --%>
      </div>

      <%-- Message Input --%>
      <div class="p-4 border-t border-slate-100 bg-white">
        <form id="chat-form" class="flex items-center gap-3" onsubmit="return false;">
          <button type="button" class="text-slate-400 hover:text-slate-600 transition-colors" title="Attach file">
            <span class="material-symbols-outlined">attach_file</span>
          </button>
          <input type="text" id="chat-input" placeholder="Type a message..."
            class="flex-1 py-2.5 px-4 bg-slate-100 border-none rounded-xl text-sm focus:ring-2 focus:ring-brand-blue/30 transition-all" />
          <button type="submit"
            class="size-10 bg-brand-blue text-white rounded-xl flex items-center justify-center hover:opacity-90 transition-all shadow-lg shadow-blue-500/20"
            title="Send">
            <span class="material-symbols-outlined">send</span>
          </button>
        </form>
      </div>
    </div>

    <%-- ===== EMPTY STATE ===== --%>
    <div class="hidden flex-1 flex flex-col items-center justify-center text-slate-400 bg-white" id="chat-empty-state">
      <div class="size-20 bg-slate-50 rounded-full flex items-center justify-center mb-4">
        <span class="material-symbols-outlined text-[40px]">chat_bubble_outline</span>
      </div>
      <p class="font-bold text-slate-800">No chat selected</p>
      <p class="text-sm">Choose a patient from the list to start messaging</p>
    </div>

  </div>
</div>

<%-- ===== Messages Page Script ===== --%>
<script>
window.__pageInit = function () {

  /* ------------------------------------------------------------------
   * Sample chat data — replace with server-side data or AJAX call.
   * Example server-side injection:
   *   var chatData = ${chatDataJson};   (set in servlet/controller)
   * ------------------------------------------------------------------ */
  var chatData = [
    {
      id: 1,
      name: 'Priya Sharma',
      pid: 'PT-001',
      unread: true,
      lastMsg: 'I need to reschedule my Friday appointment.',
      time: '10:15 AM',
      history: [
        { sender: 'patient',      text: 'Hello, I have a fever since last night.',                                         time: '09:00 AM' },
        { sender: 'receptionist', text: 'Sorry to hear that. Dr. Aryan has a slot at 11:30 AM today. Would you like to book it?', time: '09:15 AM' },
        { sender: 'patient',      text: 'I need to reschedule my Friday appointment instead.',                              time: '10:15 AM' }
      ]
    },
    {
      id: 2,
      name: 'Rohan Mehta',
      pid: 'PT-002',
      unread: false,
      lastMsg: 'Thank you for the update.',
      time: 'Yesterday',
      history: [
        { sender: 'receptionist', text: 'Your lab reports are ready for collection.', time: '04:00 PM' },
        { sender: 'patient',      text: 'Thank you for the update.',                  time: '04:05 PM' }
      ]
    },
    {
      id: 3,
      name: 'Anjali Verma',
      pid: 'PT-003',
      unread: true,
      lastMsg: 'Is the dermatologist available tomorrow?',
      time: '08:45 AM',
      history: [
        { sender: 'patient', text: 'Is the dermatologist available tomorrow?', time: '08:45 AM' }
      ]
    }
  ];

  var currentChat = chatData[0];

  /* ---------- Helpers ---------- */
  function escapeHtml(str) {
    var div = document.createElement('div');
    div.appendChild(document.createTextNode(str));
    return div.innerHTML;
  }

  /* ---------- Render patient list ---------- */
  function renderList() {
    var listEl = document.getElementById('patient-chat-list');
    listEl.innerHTML = chatData.map(function (c) {
      var isActive  = currentChat.id === c.id;
      var color     = window.avatarColor(c.name);
      var initials  = window.initials(c.name);
      return '<div onclick="window.selectChat(' + c.id + ')"' +
             ' class="p-4 flex items-center gap-3 cursor-pointer hover:bg-white transition-all border-l-4 ' +
             (isActive ? 'bg-white border-brand-blue shadow-sm' : 'border-transparent') + '">' +
               '<div class="size-11 rounded-full flex items-center justify-center text-xs font-bold shrink-0"' +
               ' style="background:' + color + '22;color:' + color + '">' +
                 initials +
               '</div>' +
               '<div class="flex-1 min-w-0">' +
                 '<div class="flex items-center justify-between mb-0.5">' +
                   '<p class="text-sm font-bold text-slate-800 truncate">' + escapeHtml(c.name) + '</p>' +
                   '<span class="text-[10px] font-medium text-slate-400">' + escapeHtml(c.time) + '</span>' +
                 '</div>' +
                 '<div class="flex items-center justify-between">' +
                   '<p class="text-xs text-slate-500 truncate pr-4">' + escapeHtml(c.lastMsg) + '</p>' +
                   (c.unread ? '<span class="size-2 bg-brand-blue rounded-full"></span>' : '') +
                 '</div>' +
               '</div>' +
             '</div>';
    }).join('');
  }

  /* ---------- Render active chat ---------- */
  function renderChat() {
    var color    = window.avatarColor(currentChat.name);
    var initials = window.initials(currentChat.name);

    /* Header */
    document.getElementById('active-chat-user').innerHTML =
      '<div class="size-10 rounded-full flex items-center justify-center text-xs font-bold"' +
      ' style="background:' + color + '22;color:' + color + '">' +
        initials +
      '</div>' +
      '<div>' +
        '<p class="text-sm font-bold text-slate-900">' + escapeHtml(currentChat.name) + '</p>' +
        '<p class="text-[10px] text-mint font-bold uppercase tracking-widest">Online</p>' +
      '</div>';

    /* Message history */
    var historyEl = document.getElementById('chat-history');
    historyEl.innerHTML = currentChat.history.map(function (m) {
      var isMe = m.sender === 'receptionist';
      return '<div class="flex ' + (isMe ? 'justify-end' : 'justify-start') + '">' +
               '<div class="max-w-[75%]">' +
                 '<div class="px-4 py-2.5 rounded-2xl text-sm ' +
                   (isMe
                     ? 'bg-brand-blue text-white rounded-tr-none shadow-md shadow-blue-500/10'
                     : 'bg-white text-slate-700 rounded-tl-none border border-slate-100 shadow-sm') + '">' +
                   escapeHtml(m.text) +
                 '</div>' +
                 '<p class="text-[10px] text-slate-400 mt-1 font-medium ' +
                   (isMe ? 'text-right' : 'text-left') + '">' +
                   escapeHtml(m.time) +
                 '</p>' +
               '</div>' +
             '</div>';
    }).join('');

    /* Auto-scroll to latest */
    setTimeout(function () {
      historyEl.scrollTop = historyEl.scrollHeight;
    }, 10);
  }

  /* ---------- Select chat ---------- */
  window.selectChat = function (id) {
    currentChat = chatData.find(function (c) { return c.id === id; });
    currentChat.unread = false;
    renderList();
    renderChat();
  };

  /* ---------- Send message ---------- */
  document.getElementById('chat-form').addEventListener('submit', function (e) {
    e.preventDefault();
    var input = document.getElementById('chat-input');
    var text  = input.value.trim();
    if (!text) return;

    currentChat.history.push({
      sender: 'receptionist',
      text:   text,
      time:   new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
    });
    currentChat.lastMsg = text;
    currentChat.time    = 'Now';

    input.value = '';
    renderList();
    renderChat();
  });

  /* ---------- Search / filter ---------- */
  document.getElementById('chat-search').addEventListener('input', function () {
    var query = this.value.toLowerCase();
    document.querySelectorAll('#patient-chat-list > div').forEach(function (el, i) {
      var name = chatData[i] ? chatData[i].name.toLowerCase() : '';
      el.style.display = name.includes(query) ? '' : 'none';
    });
  });

  /* ---------- Initial render ---------- */
  renderList();
  renderChat();
};
</script>
