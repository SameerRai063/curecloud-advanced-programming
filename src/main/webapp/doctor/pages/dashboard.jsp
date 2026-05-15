<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  dashboard.jsp — loaded as a page fragment via fetch() inside index.jsp.
  No <html>/<head>/<body> tags needed; this is injected into #page-content.

  Server-side wiring hints:
  - Stats (totalAppts, completedSessions, pendingCount, cancelledCount) should
    come from a request-scoped attribute set by a DashboardServlet / Spring
    controller, e.g. request.setAttribute("totalAppts", service.getTotalCount());
  - todaySchedule and activityItems are kept as inline JS arrays here;
    in production, serialise them server-side and expose as:
      var schedule = ${todayScheduleJson};
--%>

<!-- ── Health Summary ─────────────────────────────────────────── -->
<section class="mt-6 mb-8">
  <div class="flex items-center justify-between mb-6">
    <h2 class="text-lg font-bold text-slate-800">Health Summary</h2>
  </div>
  <div class="grid grid-cols-4 gap-6">

    <div class="bg-brand-blue p-6 rounded-2xl shadow-lg shadow-brand-blue/10 flex flex-col justify-between h-44 text-white cursor-pointer hover:-translate-y-1 transition-transform">
      <div class="bg-white/20 size-12 rounded-xl flex items-center justify-center">
        <span class="material-symbols-outlined" style="font-variation-settings:'FILL' 1">calendar_month</span>
      </div>
      <div>
        <p class="text-white/80 text-xs font-medium mb-1">Total</p>
        <%-- Replace with ${totalAppts} Appointments when wired to backend --%>
        <p class="text-lg font-bold leading-tight">124 Appointments</p>
      </div>
    </div>

    <div class="bg-mint p-6 rounded-2xl shadow-lg shadow-mint/10 flex flex-col justify-between h-44 text-white cursor-pointer hover:-translate-y-1 transition-transform">
      <div class="bg-white/20 size-12 rounded-xl flex items-center justify-center">
        <span class="material-symbols-outlined" style="font-variation-settings:'FILL' 1">check_circle</span>
      </div>
      <div>
        <p class="text-white/80 text-xs font-medium mb-1">Completed</p>
        <%-- Replace with ${completedSessions} Sessions --%>
        <p class="text-lg font-bold leading-tight">98 Sessions</p>
      </div>
    </div>

    <div class="bg-pending-blue p-6 rounded-2xl shadow-lg shadow-blue-500/10 flex flex-col justify-between h-44 text-white cursor-pointer hover:-translate-y-1 transition-transform">
      <div class="bg-white/20 size-12 rounded-xl flex items-center justify-center">
        <span class="material-symbols-outlined" style="font-variation-settings:'FILL' 1">schedule</span>
      </div>
      <div>
        <p class="text-white/80 text-xs font-medium mb-1">Status</p>
        <%-- Replace with ${pendingCount} Pending --%>
        <p class="text-lg font-bold leading-tight">18 Pending</p>
      </div>
    </div>

    <div class="bg-outstanding-orange p-6 rounded-2xl shadow-lg shadow-orange-500/10 flex flex-col justify-between h-44 text-white cursor-pointer hover:-translate-y-1 transition-transform">
      <div class="bg-white/20 size-12 rounded-xl flex items-center justify-center">
        <span class="material-symbols-outlined" style="font-variation-settings:'FILL' 1">cancel</span>
      </div>
      <div>
        <p class="text-white/80 text-xs font-medium mb-1">Cancelled</p>
        <%-- Replace with ${cancelledCount} Slots --%>
        <p class="text-lg font-bold leading-tight">8 Slots</p>
      </div>
    </div>

  </div>
</section>

<!-- ── Schedule + Activity ─────────────────────────────────────── -->
<div class="grid grid-cols-12 gap-8">

  <!-- Today's Schedule (8 cols) -->
  <section class="col-span-8">
    <div class="flex items-center justify-between mb-4">
      <h2 class="text-lg font-bold text-slate-800">Today's Schedule</h2>
      <button class="text-brand-blue font-semibold text-sm hover:underline"
        onclick="navigateTo('appointments', document.getElementById('nav-appointments'))">View all</button>
    </div>
    <div class="bg-white rounded-2xl shadow-sm border border-slate-100 overflow-hidden" id="today-schedule"></div>
  </section>

  <!-- Activity Feed (4 cols) -->
  <section class="col-span-4">
    <div class="flex items-center justify-between mb-4">
      <h2 class="text-lg font-bold text-slate-800">Recent Activity</h2>
      <button class="text-slate-400 hover:text-brand-blue transition-colors">
        <span class="material-symbols-outlined">filter_list</span>
      </button>
    </div>
    <div class="bg-white rounded-2xl shadow-sm border border-slate-100 overflow-hidden" id="activity-feed"></div>
  </section>

</div>

<script>
(function () {
  /* ── Today's schedule ─────────────────────────────────────────────
     Replace this JS array with server-side JSON in production:
       var todaySchedule = ${todayScheduleJson};
  ─────────────────────────────────────────────────────────────────── */
  var todaySchedule = [
    {time:'09:00', period:'AM', name:'Priya Sharma', type:'Cardiology \u2014 Follow-up',       status:'upcoming'},
    {time:'10:30', period:'AM', name:'Rohan Mehta',  type:'Cardiology \u2014 Consultation',    status:'pending'},
    {time:'12:00', period:'PM', name:'Anjali Verma', type:'Cardiology \u2014 Routine Checkup', status:'completed'},
    {time:'02:15', period:'PM', name:'Karan Patel',  type:'Cardiology \u2014 ECG Review',      status:'upcoming'},
    {time:'04:00', period:'PM', name:'Sneha Gupta',  type:'Cardiology \u2014 New Patient',     status:'cancelled'},
  ];

  /* ── Activity feed ────────────────────────────────────────────────
     Replace with ${activityFeedJson} from your controller.
  ─────────────────────────────────────────────────────────────────── */
  var activityItems = [
    {icon:'check_circle', color:'text-mint',               bg:'bg-mint/10',               text:"<strong>Anjali Verma</strong>'s appointment marked completed",   time:'35 minutes ago'},
    {icon:'star',         color:'text-brand-blue',         bg:'bg-brand-blue/10',         text:'<strong>Rohan M.</strong> left a 5-star review',                time:'2 hours ago'},
    {icon:'person_add',   color:'text-outstanding-orange', bg:'bg-outstanding-orange/10', text:'New patient <strong>Sneha Gupta</strong> booked an appointment', time:'3 hours ago'},
    {icon:'event_busy',   color:'text-red-400',            bg:'bg-red-50',                text:"<strong>Vijay R.</strong> cancelled their 4:00 PM slot",         time:'Yesterday, 6:42 PM'},
    {icon:'star',         color:'text-brand-blue',         bg:'bg-brand-blue/10',         text:'<strong>Priya S.</strong> left a 4-star review',                time:'Yesterday, 2:15 PM'},
  ];

  var lineColor = {upcoming:'#0052FF', pending:'#f59e0b', completed:'#70C1B3', cancelled:'#f43f5e'};

  /* Render schedule */
  document.getElementById('today-schedule').innerHTML = todaySchedule.map(function (s, i) {
    var col = window.avatarColor(s.name);
    var ini = window.initials(s.name);
    var lc  = lineColor[s.status] || '#94A3B8';
    return '<div class="flex items-center gap-4 px-6 py-4 '
      + (i < todaySchedule.length - 1 ? 'border-b border-slate-50' : '')
      + ' hover:bg-slate-50 transition-colors cursor-pointer">'
      + '<div class="text-right min-w-[52px]">'
      +   '<p class="text-sm font-bold text-slate-700">' + s.time + '</p>'
      +   '<p class="text-[11px] text-slate-400 font-medium">' + s.period + '</p>'
      + '</div>'
      + '<div class="w-[3px] h-9 rounded-full flex-shrink-0" style="background:' + lc + '"></div>'
      + '<div class="size-9 rounded-full flex items-center justify-center text-xs font-bold flex-shrink-0"'
      +   ' style="background:' + col + '22;color:' + col + '">' + ini + '</div>'
      + '<div class="flex-1 min-w-0">'
      +   '<p class="text-sm font-semibold text-slate-900">' + s.name + '</p>'
      +   '<p class="text-xs text-slate-400 mt-0.5">' + s.type + '</p>'
      + '</div>'
      + window.statusPill(s.status)
      + '</div>';
  }).join('');

  /* Render activity */
  document.getElementById('activity-feed').innerHTML = activityItems.map(function (a, i) {
    return '<div class="flex items-start gap-3 px-6 py-4 '
      + (i < activityItems.length - 1 ? 'border-b border-slate-50' : '') + '">'
      + '<div class="size-9 rounded-full flex items-center justify-center flex-shrink-0 mt-0.5 ' + a.bg + '">'
      +   '<span class="material-symbols-outlined text-[17px] ' + a.color
      +     '" style="font-variation-settings:\'FILL\' 1,\'wght\' 500">' + a.icon + '</span>'
      + '</div>'
      + '<div>'
      +   '<p class="text-sm text-slate-600 leading-snug">' + a.text + '</p>'
      +   '<p class="text-[11px] text-slate-400 mt-1">' + a.time + '</p>'
      + '</div>'
      + '</div>';
  }).join('');
})();
</script>
