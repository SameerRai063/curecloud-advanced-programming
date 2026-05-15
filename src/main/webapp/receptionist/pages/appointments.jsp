<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%--
  JSP FRAGMENT: Injected directly into index.jsp.
--%>

<div id="appt-root" class="p-6 max-w-screen-xl mx-auto">

  <%-- ── Filter Bar & Search ── --%>
  <div class="mt-6 mb-6 flex items-center gap-3">
    <div class="flex items-center bg-white border border-slate-100 rounded-2xl p-1 shadow-sm gap-1">
      <button data-filter="all"       class="appt-filter-btn px-4 py-2 rounded-xl text-sm font-semibold transition-all bg-[#2554ff] text-white shadow">All Visits</button>
      <button data-filter="upcoming"  class="appt-filter-btn px-4 py-2 rounded-xl text-sm font-semibold transition-all text-slate-500 hover:text-slate-800">Upcoming</button>
      <button data-filter="pending"   class="appt-filter-btn px-4 py-2 rounded-xl text-sm font-semibold transition-all text-slate-500 hover:text-slate-800">Arrived</button>
    </div>

    <div class="relative ml-auto">
      <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-slate-400 text-[18px]">search</span>
      <input id="appt-search" type="text" placeholder="Search patient or doctor…"
             class="pl-9 pr-4 py-2.5 bg-white border border-slate-100 rounded-2xl text-sm font-medium text-slate-700 shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-200 w-64 transition-all">
    </div>
  </div>

  <%-- ── Stats Cards ── --%>
  <div class="grid grid-cols-4 gap-4 mb-6" id="appt-stats"></div>

  <%-- ── Table ── --%>
  <div class="bg-white rounded-2xl shadow-sm border border-slate-100 overflow-hidden">
    <table class="w-full text-sm">
      <thead>
      <tr class="border-b border-slate-100 bg-slate-50/70">
        <th class="text-left px-6 py-4 text-xs font-bold text-slate-400 uppercase tracking-widest">Patient</th>
        <th class="text-left px-6 py-4 text-xs font-bold text-slate-400 uppercase tracking-widest">Assigned Doctor</th>
        <th class="text-left px-6 py-4 text-xs font-bold text-slate-400 uppercase tracking-widest">Date &amp; Time</th>
        <th class="text-left px-6 py-4 text-xs font-bold text-slate-400 uppercase tracking-widest">Status</th>
        <th class="text-right px-6 py-4 text-xs font-bold text-slate-400 uppercase tracking-widest">Actions</th>
      </tr>
      </thead>
      <tbody id="appt-tbody">
      <%-- Populated dynamically by JS below --%>
      </tbody>
    </table>
  </div>

</div>

<script>
  window.__pageInit = function() {

    // 1. Seed dynamic JSTL Data into JS (Using backticks `` to prevent apostrophe syntax errors)
    const fetchedAppointments = [
      <c:choose>
      <c:when test="${not empty appointmentList}">
      <c:forEach var="a" items="${appointmentList}" varStatus="loop">
      {
        id:         ${a.id},
        pid:        `APT-${a.id}`,
        name:       `${a.patientName}`,
        doctor:     `${a.doctorName}`,
        department: `${a.department}`,
        date:       `${a.appointmentDate}`,
        time:       `${a.appointmentTime}`,
        status:     `${a.status}`,
        reason:     `${a.reason}`
      }<c:if test="${!loop.last}">,</c:if>
      </c:forEach>
      </c:when>
      </c:choose>
    ];

    // Override global appointments if DB data exists, otherwise keep fallback data from index.jsp
    if (fetchedAppointments.length > 0) {
      window.appointments = fetchedAppointments;
    } else if (!window.appointments) {
      window.appointments = [];
    }

    // 2. Styling Override specific to Appointments page
    window.statusPill = function(status) {
      const map = {
        upcoming:  { bg: 'bg-blue-50',   text: 'text-blue-600',  label: 'Upcoming'  },
        pending:   { bg: 'bg-orange-50', text: 'text-orange-500',label: 'Arrived'   },
        completed: { bg: 'bg-teal-50',   text: 'text-teal-600',  label: 'Completed' },
        cancelled: { bg: 'bg-red-50',    text: 'text-red-500',   label: 'Cancelled' },
      };
      const s = map[status] || { bg: 'bg-slate-100', text: 'text-slate-500', label: status };
      return `<span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-[10px] font-bold uppercase tracking-wider ${s.bg} ${s.text}">
              <span class="size-1.5 rounded-full bg-current"></span>${s.label}
            </span>`;
    };

    /* NOTE: window.changeStatus is intentionally omitted here so that it
       uses the custom TailWind Confirmation Modal defined in index.jsp! */

    /* ── Core Variables ── */
    let activeFilter = 'all';
    let searchTerm   = '';

    /* ── Render Stats ── */
    function renderStats() {
      const counts = { upcoming: 0, pending: 0, completed: 0 };
      window.appointments.forEach(a => {
        if (counts[a.status] !== undefined) counts[a.status]++;
      });
      const statDefs = [
        { label: 'Total Today',  val: window.appointments.length, icon: 'today',           bg: 'bg-[#2554ff]' },
        { label: 'Expected',     val: counts.upcoming,            icon: 'event_upcoming',  bg: 'bg-blue-500'  },
        { label: 'Waiting',      val: counts.pending,             icon: 'hourglass_empty', bg: 'bg-orange-500'},
        { label: 'Completed',    val: counts.completed,           icon: 'task_alt',        bg: 'bg-teal-600'  },
      ];

      const container = document.getElementById('appt-stats');
      if (container) {
        container.innerHTML = statDefs.map(s => `
        <div class="${s.bg} p-5 rounded-2xl text-white flex items-center gap-4 shadow-sm">
          <div class="bg-white/20 size-10 rounded-xl flex items-center justify-center">
            <span class="material-symbols-outlined text-[20px]">${s.icon}</span>
          </div>
          <div>
            <p class="text-white/70 text-[11px] font-semibold uppercase tracking-wider">${s.label}</p>
            <p class="text-xl font-black">${s.val}</p>
          </div>
        </div>`).join('');
      }
    }

    /* ── Render Table ── */
    function renderTable() {
      const list = window.appointments.filter(a => {
        const matchFilter = activeFilter === 'all' || a.status === activeFilter;
        const q = searchTerm.toLowerCase();
        return matchFilter && (a.name.toLowerCase().includes(q) || a.doctor.toLowerCase().includes(q));
      });

      const tbody = document.getElementById('appt-tbody');
      if (!tbody) return;

      tbody.innerHTML = list.length === 0
              ? `<tr><td colspan="5" class="px-6 py-16 text-center text-slate-400 font-medium">No appointments found</td></tr>`
              : list.map(a => {
                // Fallbacks for functions defined in index.jsp
                const color = window.avatarColor ? window.avatarColor(a.name) : '#CBD5E1';
                const initial = window.initials ? window.initials(a.name) : 'PT';
                const pill = window.statusPill ? window.statusPill(a.status) : a.status;

                return `
            <tr class="border-b border-slate-50 last:border-0 hover:bg-slate-50/60 transition-colors">
              <td class="px-6 py-4">
                <div class="flex items-center gap-3">
                  <div class="size-9 rounded-full flex items-center justify-center text-xs font-bold"
                       style="background:${color}22;color:${color}">
                    ${initial}
                  </div>
                  <div>
                    <p class="font-semibold text-slate-900">${a.name}</p>
                    <p class="text-[11px] text-slate-400 font-medium">${a.pid}</p>
                  </div>
                </div>
              </td>
              <td class="px-6 py-4">
                <p class="font-semibold text-slate-800">${a.doctor}</p>
                <p class="text-[11px] text-[#2554ff] font-bold uppercase tracking-tighter">${a.department || 'Consultation'}</p>
              </td>
              <td class="px-6 py-4">
                <p class="font-semibold text-slate-800">${a.time}</p>
                <p class="text-[11px] text-slate-400 font-medium">${a.date}</p>
              </td>
              <td class="px-6 py-4">${pill}</td>
              <td class="px-6 py-4 text-right">
                <div class="flex items-center justify-end gap-2">
                  <button onclick="window.changeStatus(${a.id},'cancelled')"
                          class="p-2 text-slate-400 hover:text-red-500 transition-all"
                          title="Cancel Appointment">
                    <span class="material-symbols-outlined text-[20px]">cancel</span>
                  </button>
                </div>
              </td>
            </tr>`;
              }).join('');
    }

    /* ── Attach Listeners ── */
    document.querySelectorAll('.appt-filter-btn').forEach(btn => {
      btn.onclick = () => {
        activeFilter = btn.dataset.filter;
        document.querySelectorAll('.appt-filter-btn').forEach(b => {
          b.className = 'appt-filter-btn px-4 py-2 rounded-xl text-sm font-semibold transition-all text-slate-500 hover:text-slate-800';
        });
        btn.className = 'appt-filter-btn px-4 py-2 rounded-xl text-sm font-semibold transition-all bg-[#2554ff] text-white shadow';
        renderTable();
      };
    });

    const searchInput = document.getElementById('appt-search');
    if (searchInput) {
      searchInput.oninput = e => {
        searchTerm = e.target.value;
        renderTable();
      };
    }

    /* Expose for external re-render after parent Modal confirms */
    window.__apptRender = () => { renderStats(); renderTable(); };

    // Initial Load Trigger
    renderStats();
    renderTable();
  };
</script>