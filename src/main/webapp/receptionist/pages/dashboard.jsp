<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.util.List" %>
<%@ page import="Doctor.Model.Doctor" %>
<%
  // Fetch stats from request attributes matching your admin/receptionist controllers
  int totalPatients = (request.getAttribute("totalPatients") != null) ? (Integer) request.getAttribute("totalPatients") : 0;
  int activeToday = (request.getAttribute("activeToday") != null) ? (Integer) request.getAttribute("activeToday") : 0;
  int appointmentsToday = (request.getAttribute("appointmentsToday") != null) ? (Integer) request.getAttribute("appointmentsToday") : 0;

  // Fetch doctors list for the sidebar
  List<Doctor> doctorsList = null;
  Object docsObj = request.getAttribute("doctorsList");
  if (docsObj != null) {
    doctorsList = (List<Doctor>) docsObj;
  }
%>
<%--
  JSP FRAGMENT: This is injected into index.jsp.
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
          <span class="text-[11px] font-bold text-brand-blue bg-blue-50 px-2 py-1 rounded-lg uppercase tracking-wider">Recent</span>
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
  window.__pageInit = function() {

    // 1. Seed Recent Appointments using JSTL
    const fetchedAppointments = [
      <c:choose>
        <c:when test="${not empty appointmentList}">
          <c:forEach var="a" items="${appointmentList}" varStatus="loop">
          {
            id:         ${a.id},
            pid:        `${a.id}`,
            name:       `${a.patientName}`,
            doctor:     `${a.doctorName}`,
            time:       `${a.appointmentTime}`,
            status:     `${a.status}`
          }<c:if test="${!loop.last}">,</c:if>
          </c:forEach>
        </c:when>
      </c:choose>
    ];

    // Fallback to index.jsp array if database returns empty
    const dashAppointments = fetchedAppointments.length > 0 ? fetchedAppointments : (window.appointments || []);

    // 2. Seed Doctor Status using JSP Scriptlet
    const fetchedDoctors = [
      <%
        if (doctorsList != null && !doctorsList.isEmpty()) {
          for (int i = 0; i < doctorsList.size(); i++) {
            Doctor doc = doctorsList.get(i);
            String docName = (doc.getUser() != null && doc.getUser().getName() != null) ? doc.getUser().getName().replace("'", "&#39;") : "—";
            String docStatus = (doc.getStatus() != null) ? doc.getStatus() : "Unknown";
            String color = "active".equalsIgnoreCase(docStatus) ? "bg-mint" : "bg-amber-400";
      %>
      {
        name: `<%= docName %>`,
        status: `<%= "active".equalsIgnoreCase(docStatus) ? "In Clinic" : docStatus %>`,
        color: `<%= color %>`
      }<%= (i < doctorsList.size() - 1) ? "," : "" %>
      <%
          }
        }
      %>
    ];

    // 3. Render Stats (Mixing DB stats with JS Fallbacks)
    function renderStats() {
      const dbTotalPatients = <%= totalPatients %>;
      const dbActiveDocs = <%= activeToday %>;
      const apptCount = dashAppointments.length;

      const stats = [
        { label: 'Total Patients', val: dbTotalPatients > 0 ? dbTotalPatients : '1,284', icon: 'groups', color: 'text-blue-600', bg: 'bg-blue-50' },
        { label: 'Today\'s Visits', val: apptCount, icon: 'calendar_today', color: 'text-indigo-600', bg: 'bg-indigo-50' },
        { label: 'Active Doctors', val: dbActiveDocs > 0 ? dbActiveDocs : fetchedDoctors.length || '4', icon: 'medical_services', color: 'text-mint', bg: 'bg-teal-50' },
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

    // 4. Render Recent Appointments Table
    function renderRecentAppts() {
      const tbody = document.getElementById('dash-appt-tbody');
      if (!tbody) return;

      if (!dashAppointments || dashAppointments.length === 0) {
        tbody.innerHTML = `<tr><td colspan="4" class="px-6 py-10 text-center text-slate-400">No appointments scheduled.</td></tr>`;
        return;
      }

      // Show top 4 upcoming appointments
      const recent = dashAppointments.slice(0, 4);
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

    // 5. Render Doctor Status List
    function renderDoctorStatus() {
      const container = document.getElementById('dash-dr-list');
      if (!container) return;

      // Use database doctors if present, otherwise inject visual mock data
      let doctorsToRender = fetchedDoctors;
      if (doctorsToRender.length === 0) {
        doctorsToRender = [
          { name: 'Dr. Aryan Kapoor', status: 'In Clinic', color: 'bg-mint' },
          { name: 'Dr. Sneha Reddy', status: 'In Surgery', color: 'bg-amber-400' },
          { name: 'Dr. Vikram Seth', status: 'On Break', color: 'bg-slate-300' }
        ];
      }

      // Slice to keep sidebar neat
      container.innerHTML = doctorsToRender.slice(0, 5).map(d => {
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

    // Execute All Component Renderers
    renderStats();
    renderRecentAppts();
    renderDoctorStatus();
  };
</script>