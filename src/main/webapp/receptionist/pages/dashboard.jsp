<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--
  This is a JSP fragment intended to be injected into index.jsp.
  It does not need <html> or <body> tags.
--%>
<div id="dashboard-root">

  <div class="mt-6 mb-8 flex items-center justify-between">
    <div>
      <h2 class="text-xl font-bold text-slate-800">Clinic Overview</h2>
      <p class="text-sm text-slate-500">Here is what's happening at the front desk today.</p>
    </div>
    <div class="flex gap-3">
      <button onclick="navigateTo('appointments', document.getElementById('nav-appointments'))"
              class="flex items-center gap-2 px-4 py-2 bg-white border border-slate-200 text-slate-700 rounded-xl text-sm font-bold hover:bg-slate-50 transition-all shadow-sm">
        <span class="material-symbols-outlined text-[18px]">calendar_today</span>
        Full Schedule
      </button>
    </div>
  </div>

  <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8" id="dash-stats"></div>

  <div class="grid grid-cols-12 gap-8">
    <div class="col-span-12 lg:col-span-8">
      <div class="bg-white rounded-2xl border border-slate-100 shadow-sm overflow-hidden">
        <div class="px-6 py-5 border-b border-slate-50 flex items-center justify-between">
          <h3 class="font-bold text-slate-800 flex items-center gap-2">
            <span class="material-symbols-outlined text-brand-blue">timer</span>
            Upcoming Appointments
          </h3>
          <span class="text-[11px] font-bold text-brand-blue bg-blue-50 px-2 py-1 rounded-lg uppercase tracking-wider">Next 4 Hours</span>
        </div>
        <div class="overflow-x-auto">
          <table class="w-full text-sm">
            <thead class="bg-slate-50/50">
            <tr>
              <th class="text-left px-6 py-3 text-xs font-bold text-slate-400 uppercase tracking-widest">Patient</th>
              <th class="text-left px-6 py-3 text-xs font-bold text-slate-400 uppercase tracking-widest">Time</th>
              <th class="text-left px-6 py-3 text-xs font-bold text-slate-400 uppercase tracking-widest">Doctor</th>
              <th class="text-right px-6 py-3 text-xs font-bold text-slate-400 uppercase tracking-widest">Status</th>
            </tr>
            </thead>
            <tbody id="dash-appt-tbody"></tbody>
          </table>
        </div>
        <div class="p-4 bg-slate-50/30 text-center">
          <button onclick="navigateTo('appointments', document.getElementById('nav-appointments'))"
                  class="text-xs font-bold text-slate-500 hover:text-brand-blue transition-colors uppercase tracking-widest">
            View All Appointments
          </button>
        </div>
      </div>
    </div>

    <div class="col-span-12 lg:col-span-4">
      <div class="bg-white rounded-2xl border border-slate-100 shadow-sm p-6">
        <h3 class="font-bold text-slate-800 mb-4 flex items-center gap-2">
          <span class="material-symbols-outlined text-mint">person_search</span>
          Doctor Status
        </h3>
        <div class="space-y-4" id="dash-dr-list"></div>
      </div>
    </div>
  </div>
</div>

<script>
  /**
   * Bug Fix: window.__pageInit is used by index.jsp to trigger
   * the rendering after the AJAX content is loaded.
   */
  window.__pageInit = function() {

    // 1. Render Stats
    function renderStats() {
      // Bug Fix: Check if window.appointments exists to prevent errors
      const apptCount = (window.appointments && window.appointments.length) ? window.appointments.length : 0;

      const stats = [
        { label: 'Total Patients', val: '1,284', icon: 'groups', color: 'text-blue-600', bg: 'bg-blue-50' },
        { label: 'Today\'s Visits', val: apptCount, icon: 'calendar_today', color: 'text-indigo-600', bg: 'bg-indigo-50' },
        { label: 'New Reviews', val: '4', icon: 'star', color: 'text-amber-600', bg: 'bg-amber-50' },
      ];

      const container = document.getElementById('dash-stats');
      if (container) {
        container.innerHTML = stats.map(s => `
        <div class="bg-white p-6 rounded-2xl border border-slate-100 shadow-sm flex items-center gap-4">
          <div class="${s.bg} ${s.color} size-12 rounded-2xl flex items-center justify-center">
            <span class="material-symbols-outlined text-[28px]">${s.icon}</span>
          </div>
          <div>
            <p class="text-xs font-bold text-slate-400 uppercase tracking-widest">${s.label}</p>
            <p class="text-2xl font-black text-slate-800">${s.val}</p>
          </div>
        </div>
      `).join('');
      }
    }

    // 2. Render Recent Appointments
    function renderRecentAppts() {
      const tbody = document.getElementById('dash-appt-tbody');
      if (!tbody) return;

      // Bug Fix: Handle empty or missing appointments gracefully
      if (!window.appointments || window.appointments.length === 0) {
        tbody.innerHTML = `<tr><td colspan="4" class="px-6 py-10 text-center text-slate-400">No appointments scheduled for today.</td></tr>`;
        return;
      }

      const recent = window.appointments.slice(0, 4);

      tbody.innerHTML = recent.map(a => {
        const color = window.avatarColor ? window.avatarColor(a.name) : '#CBD5E1';
        const initial = window.initials ? window.initials(a.name) : '??';
        const statusPill = window.statusPill ? window.statusPill(a.status) : a.status;

        return `
        <tr class="border-b border-slate-50 last:border-0 hover:bg-slate-50/50 transition-colors">
          <td class="px-6 py-4">
            <div class="flex items-center gap-3">
              <div class="size-8 rounded-full flex items-center justify-center text-[10px] font-bold"
                   style="background:${color}22;color:${color}">
                ${initial}
              </div>
              <div>
                <p class="font-bold text-slate-800">${a.name}</p>
                <p class="text-[11px] text-slate-400 font-medium">${a.pid}</p>
              </div>
            </div>
          </td>
          <td class="px-6 py-4 font-semibold text-slate-600">${a.time}</td>
          <td class="px-6 py-4 text-slate-500 font-medium">${a.doctor}</td>
          <td class="px-6 py-4 text-right">${statusPill}</td>
        </tr>
      `;
      }).join('');
    }

    // 3. Render Doctor List
    function renderDoctorStatus() {
      const container = document.getElementById('dash-dr-list');
      if (!container) return;

      const doctors = [
        { name: 'Dr. Aryan Kapoor', status: 'In Clinic', color: 'bg-mint' },
        { name: 'Dr. Sneha Reddy', status: 'In Surgery', color: 'bg-amber-400' },
        { name: 'Dr. Vikram Seth', status: 'On Break', color: 'bg-slate-300' }
      ];

      container.innerHTML = doctors.map(d => {
        const initial = window.initials ? window.initials(d.name) : 'DR';
        return `
        <div class="flex items-center justify-between p-3 rounded-xl border border-slate-50 hover:bg-slate-50 transition-all">
          <div class="flex items-center gap-3">
            <div class="size-8 rounded-full bg-slate-100 flex items-center justify-center text-[10px] font-bold text-slate-400">
              ${initial}
            </div>
            <span class="text-sm font-bold text-slate-700">${d.name}</span>
          </div>
          <div class="flex items-center gap-2">
            <span class="size-2 rounded-full ${d.color}"></span>
            <span class="text-[11px] font-bold text-slate-500 uppercase tracking-tighter">${d.status}</span>
          </div>
        </div>
      `;
      }).join('');
    }

    // Execute All Renderers
    renderStats();
    renderRecentAppts();
    renderDoctorStatus();
  };
</script>