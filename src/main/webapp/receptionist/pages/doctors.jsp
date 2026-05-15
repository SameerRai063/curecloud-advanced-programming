<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="Doctor.Model.Doctor" %>
<%
  String userName = (session.getAttribute("userName") != null) ? (String) session.getAttribute("userName") : "Admin";
  String userRole = (session.getAttribute("userRole") != null) ? (String) session.getAttribute("userRole") : "Receptionist";

  int totalDoctors = (request.getAttribute("totalDoctors") != null) ? (Integer) request.getAttribute("totalDoctors") : 0;
  int onLeave      = (request.getAttribute("onLeave")      != null) ? (Integer) request.getAttribute("onLeave")      : 0;

  List<Doctor> doctorsList = null;
  Object obj = request.getAttribute("doctorsList");
  if (obj != null) {
    doctorsList = (List<Doctor>) obj;
  }

  String errorMessage = (String) request.getAttribute("errorMessage");
  String errorClass   = (String) request.getAttribute("errorClass");

  // Parameters from DeleteDoctorServlet (post-redirect-get)
  String successParam = request.getParameter("success");
  String errorParam   = request.getParameter("error");
%>

<%--
  JSP FRAGMENT: Injected directly into index.jsp.
  Do NOT add <html>, <head>, or <body> tags.
--%>

<style>
  @keyframes fadeInAlert { from { opacity:0; transform:translateY(-8px); } to { opacity:1; transform:translateY(0); } }
  .alert-box { animation: fadeInAlert 0.3s ease; }
</style>

<div id="doctor-root" class="p-6 max-w-screen-xl mx-auto">

  <%-- ── Error / Success Banners ── --%>
  <% if (errorMessage != null) { %>
  <div class="mb-4 flex items-center gap-3 bg-red-50 border border-red-200 text-red-700 rounded-2xl px-5 py-3 text-sm font-medium">
    <span class="material-symbols-outlined text-[18px]">error</span>
    <strong>Database Error:</strong>&nbsp;[<%= errorClass %>] <%= errorMessage %>
  </div>
  <% } %>

  <% if ("deleted".equals(successParam)) { %>
  <div class="alert-box mb-4 flex items-center gap-3 bg-teal-50 border border-teal-200 text-teal-700 rounded-2xl px-5 py-3 text-sm font-medium" id="alertBox">
    <span class="material-symbols-outlined text-[18px]">check_circle</span>
    Doctor has been successfully removed from the system.
  </div>
  <% } else if (errorParam != null) { %>
  <div class="alert-box mb-4 flex items-center gap-3 bg-red-50 border border-red-200 text-red-700 rounded-2xl px-5 py-3 text-sm font-medium" id="alertBox">
    <span class="material-symbols-outlined text-[18px]">cancel</span>
    <% if ("not_found".equals(errorParam)) { %>
    Doctor not found in the database.
    <% } else if ("delete_failed".equals(errorParam)) { %>
    Could not delete doctor. Ensure no active appointments exist.
    <% } else { %>
    An unexpected error occurred.
    <% } %>
  </div>
  <% } %>

  <%-- ── Filter Bar & Search ── --%>
  <div class="mt-6 mb-6 flex items-center gap-3 flex-wrap">
    <div class="flex items-center bg-white border border-slate-100 rounded-2xl p-1 shadow-sm gap-1">
      <button data-filter="all"      class="doc-filter-btn px-4 py-2 rounded-xl text-sm font-semibold transition-all bg-[#2554ff] text-white shadow">All Doctors</button>
      <button data-filter="on-duty"  class="doc-filter-btn px-4 py-2 rounded-xl text-sm font-semibold transition-all text-slate-500 hover:text-slate-800">On Duty</button>
      <button data-filter="off-duty" class="doc-filter-btn px-4 py-2 rounded-xl text-sm font-semibold transition-all text-slate-500 hover:text-slate-800">Off Duty</button>
    </div>

    <div class="relative ml-auto">
      <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-slate-400 text-[18px]">search</span>
      <input id="doc-search" type="text" placeholder="Search doctor or specialty…"
             class="pl-9 pr-4 py-2.5 bg-white border border-slate-100 rounded-2xl text-sm font-medium text-slate-700 shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-200 w-64 transition-all">
    </div>
  </div>

  <%-- ── Stats Cards ── --%>
  <div class="grid grid-cols-4 gap-4 mb-6" id="doc-stats"></div>

  <%-- ── Table ── --%>
  <div class="bg-white rounded-2xl shadow-sm border border-slate-100 overflow-hidden">
    <table class="w-full text-sm">
      <thead>
      <tr class="border-b border-slate-100 bg-slate-50/70">
        <th class="text-left px-6 py-4 text-xs font-bold text-slate-400 uppercase tracking-widest">Doctor</th>
        <th class="text-left px-6 py-4 text-xs font-bold text-slate-400 uppercase tracking-widest">Specialty</th>
        <th class="text-left px-6 py-4 text-xs font-bold text-slate-400 uppercase tracking-widest">Experience</th>
        <th class="text-left px-6 py-4 text-xs font-bold text-slate-400 uppercase tracking-widest">Status</th>
        <th class="text-right px-6 py-4 text-xs font-bold text-slate-400 uppercase tracking-widest">Actions</th>
      </tr>
      </thead>
      <tbody id="doc-tbody">
      <%-- Populated by JS below --%>
      </tbody>
    </table>
  </div>

</div>

<%-- ── Doctor View Modal ── --%>
<div id="viewModal"
     class="fixed inset-0 z-50 flex items-center justify-center bg-slate-900/60 opacity-0 invisible transition-all duration-300">
  <div class="bg-white w-full max-w-[540px] rounded-2xl shadow-2xl overflow-hidden transform -translate-y-4 transition-transform duration-300" id="modalCard">

    <div class="flex items-center justify-between px-6 py-5 border-b border-slate-100 bg-slate-50">
      <h3 class="text-lg font-bold text-slate-800">Doctor Profile</h3>
      <button onclick="closeDocModal()" class="text-slate-400 hover:text-red-500 transition-colors">
        <span class="material-symbols-outlined">close</span>
      </button>
    </div>

    <div class="px-6 py-5">
      <%-- Avatar + Name header --%>
      <div class="flex items-center gap-4 pb-5 mb-5 border-b border-slate-100">
        <div id="modalAvatar"
             class="size-16 rounded-full bg-teal-100 text-teal-700 flex items-center justify-center text-2xl font-bold uppercase">D</div>
        <div>
          <h4 id="modalName" class="text-lg font-bold text-slate-900">—</h4>
          <p id="modalDepartment" class="text-sm text-slate-500 mt-0.5">—</p>
          <span id="modalStatus"
                class="mt-1.5 inline-flex items-center gap-1.5 px-3 py-0.5 rounded-full text-[10px] font-bold uppercase tracking-wider bg-teal-50 text-teal-600">Active</span>
        </div>
      </div>

      <%-- Details grid --%>
      <div class="grid grid-cols-2 gap-5">
        <div><p class="text-[11px] text-slate-400 uppercase font-semibold mb-1">Doctor ID</p><p id="modalId" class="text-sm font-semibold text-slate-800">—</p></div>
        <div><p class="text-[11px] text-slate-400 uppercase font-semibold mb-1">Experience</p><p id="modalExperience" class="text-sm font-semibold text-slate-800">—</p></div>
        <div class="col-span-2"><p class="text-[11px] text-slate-400 uppercase font-semibold mb-1">Qualifications</p><p id="modalQualifications" class="text-sm font-semibold text-slate-800">—</p></div>
        <div><p class="text-[11px] text-slate-400 uppercase font-semibold mb-1">Phone</p><p id="modalPhone" class="text-sm font-semibold text-slate-800">—</p></div>
        <div><p class="text-[11px] text-slate-400 uppercase font-semibold mb-1">Email</p><p id="modalEmail" class="text-sm font-semibold text-slate-800">—</p></div>
        <div><p class="text-[11px] text-slate-400 uppercase font-semibold mb-1">Gender</p><p id="modalGender" class="text-sm font-semibold text-slate-800 capitalize">—</p></div>
      </div>
    </div>

  </div>
</div>

<script>
  /**
   * index.jsp calls window.__pageInit() after injecting the HTML into the DOM.
   */
  window.__pageInit = function() {

    // 1. Seed window.doctors using backticks for template literal safety
    window.doctors = [
      <%
        if (doctorsList != null && !doctorsList.isEmpty()) {
          for (int i = 0; i < doctorsList.size(); i++) {
            Doctor doc = doctorsList.get(i);
            String docName   = (doc.getUser() != null && doc.getUser().getName() != null) ? doc.getUser().getName().replace("'","&#39;") : "—";
            String docDept   = (doc.getDepartment()     != null) ? doc.getDepartment().replace("'","&#39;")     : "—";
            String docQual   = (doc.getQualifications() != null) ? doc.getQualifications().replace("'","&#39;") : "—";
            String docStatus = (doc.getStatus()         != null) ? doc.getStatus()                             : "—";
            String docPhone  = (doc.getUser() != null && doc.getUser().getPhone() != null) ? doc.getUser().getPhone() : "—";
            String docEmail  = (doc.getUser() != null && doc.getUser().getEmail() != null) ? doc.getUser().getEmail() : "—";
            String docGender = (doc.getUser() != null && doc.getUser().getGender()!= null) ? doc.getUser().getGender(): "—";

            String filterStatus = "active".equalsIgnoreCase(docStatus) ? "on-duty" : "off-duty";
      %>
      {
        id:             <%= doc.getUserId() %>,
        name:           `<%= docName %>`,
        docId:          `DOC-<%= String.format("%03d", doc.getUserId()) %>`,
        specialty:      `<%= docDept %>`,
        experience:     `<%= doc.getExperienceYears() %> yrs`,
        qualifications: `<%= docQual %>`,
        status:         `<%= filterStatus %>`,
        rawStatus:      `<%= docStatus %>`,
        phone:          `<%= docPhone %>`,
        email:          `<%= docEmail %>`,
        gender:         `<%= docGender %>`
      }<%= (i < doctorsList.size() - 1) ? "," : "" %>
      <%
          }
        }
      %>
    ];

    /* ── Stats ── */
    function renderStats() {
      const onDutyCount  = window.doctors.filter(d => d.status === 'on-duty').length;
      const statDefs = [
        { label: 'Total Doctors',      val: <%= totalDoctors %>, icon: 'medical_services', bg: 'bg-[#2554ff]',  shadow: 'shadow-blue-400/20'   },
        { label: 'Currently On-Duty',  val: onDutyCount,         icon: 'person_check',     bg: 'bg-[#0d7f6b]',  shadow: 'shadow-teal-400/20'   },
        { label: 'Total Slots Today',  val: 48,                  icon: 'event_note',       bg: 'bg-[#f97316]',  shadow: 'shadow-orange-400/20' },
        { label: 'On Leave',           val: <%= onLeave %>,      icon: 'calendar_month',   bg: 'bg-slate-400',  shadow: 'shadow-slate-300/30'  },
      ];

      const container = document.getElementById('doc-stats');
      if (container) {
        container.innerHTML = statDefs.map(s => `
        <div class="${s.bg} ${s.shadow} shadow-lg p-5 rounded-2xl text-white flex items-center gap-4">
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

    /* ── Table ── */
    let activeFilter = 'all';
    let searchTerm   = '';

    function renderTable() {
      const list = window.doctors.filter(d => {
        const matchFilter = activeFilter === 'all' || d.status === activeFilter;
        const matchSearch = !searchTerm || d.name.toLowerCase().includes(searchTerm.toLowerCase()) || d.specialty.toLowerCase().includes(searchTerm.toLowerCase());
        return matchFilter && matchSearch;
      });

      const tbody = document.getElementById('doc-tbody');
      if (!tbody) return;

      tbody.innerHTML = list.length === 0
              ? `<tr><td colspan="5" class="px-6 py-16 text-center text-slate-400 font-medium">No doctors found.</td></tr>`
              : list.map(d => {
                const isOnDuty = d.status === 'on-duty';
                const initial = window.initials ? window.initials(d.name) : d.name.charAt(0);
                const color = window.avatarColor ? window.avatarColor(d.name) : '#CBD5E1';

                return `
        <tr class="border-b border-slate-50 last:border-0 hover:bg-slate-50/60 transition-colors">
          <td class="px-6 py-4">
            <div class="flex items-center gap-3">
              <div class="size-9 rounded-full flex items-center justify-center text-xs font-bold"
                   style="background:${color}22;color:${color}">
                ${initial}
              </div>
              <div>
                <p class="font-semibold text-slate-900">${d.name}</p>
                <p class="text-[11px] text-slate-400 font-medium">${d.docId}</p>
              </div>
            </div>
          </td>
          <td class="px-6 py-4 text-slate-700 font-medium">${d.specialty}</td>
          <td class="px-6 py-4 text-slate-600 font-medium">${d.experience}</td>
          <td class="px-6 py-4">
            <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-[10px] font-bold uppercase tracking-wider
                         ${isOnDuty ? 'bg-teal-50 text-teal-600' : 'bg-slate-100 text-slate-500'}">
              <span class="size-1.5 rounded-full bg-current"></span>${d.status.replace('-',' ')}
            </span>
          </td>
          <td class="px-6 py-4 text-right">
            <button onclick="window.openDocModal(this)"
                    data-id="${d.id}"
                    data-name="${d.name}"
                    data-department="${d.specialty}"
                    data-experience="${d.experience}"
                    data-status="${d.rawStatus}"
                    data-qualifications="${d.qualifications}"
                    data-phone="${d.phone}"
                    data-email="${d.email}"
                    data-gender="${d.gender}"
                    class="px-4 py-1.5 bg-[#2554ff]/5 text-[#2554ff] rounded-xl text-xs font-bold hover:bg-[#2554ff]/10 transition-all">
              View Profile
            </button>
          </td>
        </tr>`;
              }).join('');
    }

    /* ── Modal logic ── */
    // Attached to the global window object so inline HTML 'onclick' can find it.
    window.openDocModal = function(btn) {
      const name   = btn.getAttribute('data-name')   || 'N/A';
      const status = btn.getAttribute('data-status') || '';

      document.getElementById('modalAvatar').innerText       = name.charAt(0).toUpperCase();
      document.getElementById('modalName').innerText         = name;
      document.getElementById('modalId').innerText           = btn.getAttribute('data-id')             || 'N/A';
      document.getElementById('modalDepartment').innerText   = btn.getAttribute('data-department')     || 'N/A';
      document.getElementById('modalExperience').innerText   = btn.getAttribute('data-experience')    || 'N/A';
      document.getElementById('modalQualifications').innerText = btn.getAttribute('data-qualifications') || 'N/A';
      document.getElementById('modalPhone').innerText        = btn.getAttribute('data-phone')          || 'N/A';
      document.getElementById('modalEmail').innerText        = btn.getAttribute('data-email')          || 'N/A';
      document.getElementById('modalGender').innerText       = btn.getAttribute('data-gender')         || 'N/A';

      const badge = document.getElementById('modalStatus');
      if (status.toLowerCase() === 'active') {
        badge.innerText = 'Active';
        badge.className = 'mt-1.5 inline-flex items-center gap-1.5 px-3 py-0.5 rounded-full text-[10px] font-bold uppercase tracking-wider bg-teal-50 text-teal-600';
      } else if (status.toLowerCase() === 'on leave') {
        badge.innerText = 'On Leave';
        badge.className = 'mt-1.5 inline-flex items-center gap-1.5 px-3 py-0.5 rounded-full text-[10px] font-bold uppercase tracking-wider bg-red-50 text-red-600';
      } else {
        badge.innerText = status;
        badge.className = 'mt-1.5 inline-flex items-center gap-1.5 px-3 py-0.5 rounded-full text-[10px] font-bold uppercase tracking-wider bg-slate-100 text-slate-500';
      }

      const overlay = document.getElementById('viewModal');
      overlay.classList.remove('opacity-0','invisible');
      overlay.classList.add('opacity-100','visible');
      document.getElementById('modalCard').classList.remove('-translate-y-4');
    };

    window.closeDocModal = function() {
      const overlay = document.getElementById('viewModal');
      if (overlay) {
        overlay.classList.add('opacity-0','invisible');
        overlay.classList.remove('opacity-100','visible');
        document.getElementById('modalCard').classList.add('-translate-y-4');
      }
    };

    // Close modal when clicking outside of it
    const viewModal = document.getElementById('viewModal');
    if (viewModal) {
      viewModal.addEventListener('click', function(e) {
        if (e.target === viewModal) window.closeDocModal();
      });
    }

    /* ── Filter & Search Listeners ── */
    document.querySelectorAll('.doc-filter-btn').forEach(btn => {
      btn.onclick = () => {
        activeFilter = btn.dataset.filter;
        document.querySelectorAll('.doc-filter-btn').forEach(b =>
                b.className = 'doc-filter-btn px-4 py-2 rounded-xl text-sm font-semibold transition-all text-slate-500 hover:text-slate-800');
        btn.className = 'doc-filter-btn px-4 py-2 rounded-xl text-sm font-semibold transition-all bg-[#2554ff] text-white shadow';
        renderTable();
      };
    });

    const searchInput = document.getElementById('doc-search');
    if (searchInput) {
      searchInput.oninput = e => { searchTerm = e.target.value; renderTable(); };
    }

    /* ── Auto-dismiss alerts (Fixed for SPA) ── */
    const alertBox = document.getElementById('alertBox');
    if (alertBox) {
      setTimeout(() => {
        alertBox.style.transition = 'opacity 0.5s ease';
        alertBox.style.opacity   = '0';
        setTimeout(() => alertBox.remove(), 500);
      }, 4000);
    }

    // Execute Initial Render
    renderStats();
    renderTable();
  };
</script>