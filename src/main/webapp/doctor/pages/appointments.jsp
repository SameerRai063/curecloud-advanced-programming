<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<div id="appt-root">

  <!-- Filter Bar -->
  <div class="mt-6 mb-6 flex items-center gap-3 flex-wrap">
    <div class="flex items-center bg-white border border-slate-100 rounded-2xl p-1 shadow-sm gap-1">
      <button data-filter="all"       class="appt-filter-btn px-4 py-2 rounded-xl text-sm font-semibold transition-all bg-brand-blue text-white shadow">All</button>
      <button data-filter="upcoming"  class="appt-filter-btn px-4 py-2 rounded-xl text-sm font-semibold transition-all text-slate-500 hover:text-slate-800">Upcoming</button>
      <button data-filter="pending"   class="appt-filter-btn px-4 py-2 rounded-xl text-sm font-semibold transition-all text-slate-500 hover:text-slate-800">Pending</button>
      <button data-filter="completed" class="appt-filter-btn px-4 py-2 rounded-xl text-sm font-semibold transition-all text-slate-500 hover:text-slate-800">Completed</button>
      <button data-filter="cancelled" class="appt-filter-btn px-4 py-2 rounded-xl text-sm font-semibold transition-all text-slate-500 hover:text-slate-800">Cancelled</button>
    </div>
    <!-- Search -->
    <div class="relative ml-auto">
      <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-slate-400 text-[18px]">search</span>
      <input id="appt-search" type="text" placeholder="Search patient&hellip;"
        class="pl-9 pr-4 py-2.5 bg-white border border-slate-100 rounded-2xl text-sm font-medium text-slate-700 shadow-sm focus:outline-none focus:ring-2 focus:ring-brand-blue/30 w-56 transition-all">
    </div>
  </div>

  <!-- Stats row -->
  <div class="grid grid-cols-4 gap-4 mb-6" id="appt-stats"></div>

  <!-- Table -->
  <div class="bg-white rounded-2xl shadow-sm border border-slate-100 overflow-hidden">
    <table class="w-full text-sm">
      <thead>
        <tr class="border-b border-slate-100 bg-slate-50/70">
          <th class="text-left px-6 py-4 text-xs font-bold text-slate-400 uppercase tracking-widest">Patient</th>
          <th class="text-left px-6 py-4 text-xs font-bold text-slate-400 uppercase tracking-widest">Date &amp; Time</th>
          <th class="text-left px-6 py-4 text-xs font-bold text-slate-400 uppercase tracking-widest">Type</th>
          <th class="text-left px-6 py-4 text-xs font-bold text-slate-400 uppercase tracking-widest">Status</th>
          <th class="text-right px-6 py-4 text-xs font-bold text-slate-400 uppercase tracking-widest">Actions</th>
        </tr>
      </thead>
      <tbody id="appt-tbody"></tbody>
    </table>
    <div id="appt-empty" class="hidden py-20 text-center">
      <div class="inline-flex items-center justify-center size-16 rounded-2xl bg-slate-100 mb-4">
        <span class="material-symbols-outlined text-slate-400 text-[32px]">calendar_off</span>
      </div>
      <p class="text-slate-500 font-medium">No appointments found</p>
      <p class="text-slate-400 text-xs mt-1">Try a different filter or search term</p>
    </div>
  </div>

  <!-- Count -->
  <p id="appt-count" class="text-xs text-slate-400 font-medium mt-4 px-1"></p>

</div>

<script>
window.__pageInit = function () {

  var activeFilter = 'all';
  var searchTerm   = '';

  /* ── Stats ──────────────────────────────────────────────────────── */
  function renderStats() {
    var counts = {all:0, upcoming:0, pending:0, completed:0, cancelled:0};
    window.appointments.forEach(function (a) { counts.all++; counts[a.status]++; });

    var statDefs = [
      {key:'upcoming',  label:'Upcoming',  icon:'event_available', bg:'bg-brand-blue',        shadow:'shadow-brand-blue/20'},
      {key:'pending',   label:'Pending',   icon:'schedule',        bg:'bg-outstanding-orange', shadow:'shadow-orange-400/20'},
      {key:'completed', label:'Completed', icon:'check_circle',    bg:'bg-mint',              shadow:'shadow-teal-400/20'},
      {key:'cancelled', label:'Cancelled', icon:'cancel',          bg:'bg-slate-400',          shadow:'shadow-slate-300/30'},
    ];

    document.getElementById('appt-stats').innerHTML = statDefs.map(function (s) {
      return '<div class="' + s.bg + ' ' + s.shadow + ' shadow-lg p-5 rounded-2xl text-white flex items-center gap-4 cursor-pointer hover:-translate-y-0.5 transition-transform"'
        + ' onclick="document.querySelector(\'[data-filter=' + s.key + ']\').click()">'
        + '<div class="bg-white/20 size-10 rounded-xl flex items-center justify-center flex-shrink-0">'
        +   '<span class="material-symbols-outlined text-[20px]" style="font-variation-settings:\'FILL\' 1">' + s.icon + '</span>'
        + '</div>'
        + '<div>'
        +   '<p class="text-white/70 text-[11px] font-semibold uppercase tracking-wider">' + s.label + '</p>'
        +   '<p class="text-xl font-black leading-tight">' + counts[s.key] + '</p>'
        + '</div>'
        + '</div>';
    }).join('');
  }

  /* ── Table ───────────────────────────────────────────────────────── */
  function renderTable() {
    var list = window.appointments.filter(function (a) {
      var matchFilter = activeFilter === 'all' || a.status === activeFilter;
      var q = searchTerm.toLowerCase();
      var matchSearch = !q
        || a.name.toLowerCase().includes(q)
        || a.pid.toLowerCase().includes(q)
        || a.type.toLowerCase().includes(q);
      return matchFilter && matchSearch;
    });

    var tbody = document.getElementById('appt-tbody');
    var empty = document.getElementById('appt-empty');
    var count = document.getElementById('appt-count');

    if (!list.length) {
      tbody.innerHTML = '';
      empty.classList.remove('hidden');
      count.textContent = '';
      return;
    }
    empty.classList.add('hidden');
    count.textContent = 'Showing ' + list.length + ' of ' + window.appointments.length + ' appointments';

    tbody.innerHTML = list.map(function (a) {
      var col      = window.avatarColor(a.name);
      var ini      = window.initials(a.name);
      var isActive = a.status !== 'completed' && a.status !== 'cancelled';
      return '<tr class="border-b border-slate-50 last:border-0 hover:bg-slate-50/60 transition-colors">'
        + '<td class="px-6 py-4">'
        +   '<div class="flex items-center gap-3">'
        +     '<div class="size-9 rounded-full flex items-center justify-center text-xs font-bold flex-shrink-0"'
        +          ' style="background:' + col + '22;color:' + col + '">' + ini + '</div>'
        +     '<div>'
        +       '<p class="font-semibold text-slate-900">' + a.name + '</p>'
        +       '<p class="text-[11px] text-slate-400 font-medium mt-0.5">' + a.pid + '</p>'
        +     '</div>'
        +   '</div>'
        + '</td>'
        + '<td class="px-6 py-4">'
        +   '<p class="font-semibold text-slate-800">' + a.date + '</p>'
        +   '<p class="text-[11px] text-slate-400 mt-0.5 font-medium">' + a.time + '</p>'
        + '</td>'
        + '<td class="px-6 py-4">'
        +   '<span class="inline-flex items-center gap-1.5 px-3 py-1 bg-slate-100 text-slate-600 rounded-full text-[11px] font-semibold">'
        +     '<span class="material-symbols-outlined text-[13px]">stethoscope</span>' + a.type
        +   '</span>'
        + '</td>'
        + '<td class="px-6 py-4">' + window.statusPill(a.status) + '</td>'
        + '<td class="px-6 py-4">'
        +   '<div class="flex items-center justify-end gap-2">'
        +   (isActive
              ? '<button onclick="window.changeStatus(' + a.id + ',\'completed\')"'
              +   ' class="inline-flex items-center gap-1.5 px-3 py-1.5 bg-mint/10 text-teal-700 rounded-xl text-xs font-bold hover:bg-mint/20 transition-colors">'
              +   '<span class="material-symbols-outlined text-[14px]">check_circle</span>Complete</button>'
              + '<button onclick="window.changeStatus(' + a.id + ',\'cancelled\')"'
              +   ' class="inline-flex items-center gap-1.5 px-3 py-1.5 bg-red-50 text-red-500 rounded-xl text-xs font-bold hover:bg-red-100 transition-colors">'
              +   '<span class="material-symbols-outlined text-[14px]">cancel</span>Cancel</button>'
              : '<span class="text-xs text-slate-300 font-medium italic">No actions</span>')
        +   '</div>'
        + '</td>'
        + '</tr>';
    }).join('');
  }

  /* ── Filter buttons ─────────────────────────────────────────────── */
  document.querySelectorAll('.appt-filter-btn').forEach(function (btn) {
    btn.addEventListener('click', function () {
      activeFilter = btn.dataset.filter;
      document.querySelectorAll('.appt-filter-btn').forEach(function (b) {
        b.className = 'appt-filter-btn px-4 py-2 rounded-xl text-sm font-semibold transition-all text-slate-500 hover:text-slate-800';
      });
      btn.className = 'appt-filter-btn px-4 py-2 rounded-xl text-sm font-semibold transition-all bg-brand-blue text-white shadow';
      renderTable();
    });
  });

  document.getElementById('appt-search').addEventListener('input', function (e) {
    searchTerm = e.target.value;
    renderTable();
  });

  /* Re-render hook called by index.jsp after modal confirm */
  window.__apptRender = function () { renderStats(); renderTable(); };

  renderStats();
  renderTable();
};
window.__pageInit();
</script>
