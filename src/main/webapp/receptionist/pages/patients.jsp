<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%--
  JSP FRAGMENT: Injected directly into index.jsp.
  Do NOT add <html>, <head>, or <body> tags.
--%>

<div id="patient-root">

  <%-- ── Filter Bar & Search ── --%>
  <div class="mt-6 mb-6 flex items-center gap-3 flex-wrap">
    <div class="flex items-center bg-white border border-slate-100 rounded-2xl p-1 shadow-sm gap-1">
      <button data-filter="all"      class="pat-filter-btn px-4 py-2 rounded-xl text-sm font-semibold transition-all bg-[#0052FF] text-white shadow">All Patients</button>
      <button data-filter="active"   class="pat-filter-btn px-4 py-2 rounded-xl text-sm font-semibold transition-all text-slate-500 hover:text-slate-800">Active</button>
      <button data-filter="inactive" class="pat-filter-btn px-4 py-2 rounded-xl text-sm font-semibold transition-all text-slate-500 hover:text-slate-800">Inactive</button>
    </div>

    <div class="flex items-center gap-2 ml-auto">
      <div class="relative">
        <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-slate-400 text-[18px]">search</span>
        <input id="pat-search" type="text" placeholder="Search by name or ID…"
               class="pl-9 pr-4 py-2.5 bg-white border border-slate-100 rounded-2xl text-sm font-medium text-slate-700 shadow-sm focus:outline-none focus:ring-2 focus:ring-blue-200 w-64 transition-all">
      </div>
    </div>
  </div>

  <%-- ── Stats Cards ── --%>
  <div class="grid grid-cols-4 gap-4 mb-6" id="pat-stats"></div>

  <%-- ── Table ── --%>
  <div class="bg-white rounded-2xl shadow-sm border border-slate-100 overflow-hidden">
    <table class="w-full text-sm">
      <thead>
      <tr class="border-b border-slate-100 bg-slate-50/70">
        <th class="text-left px-6 py-4 text-xs font-bold text-slate-400 uppercase tracking-widest">Patient</th>
        <th class="text-left px-6 py-4 text-xs font-bold text-slate-400 uppercase tracking-widest">Age / Gender</th>
        <th class="text-left px-6 py-4 text-xs font-bold text-slate-400 uppercase tracking-widest">Contact Info</th>
        <th class="text-left px-6 py-4 text-xs font-bold text-slate-400 uppercase tracking-widest">Last Visit</th>
        <th class="text-left px-6 py-4 text-xs font-bold text-slate-400 uppercase tracking-widest">Status</th>
        <th class="text-right px-6 py-4 text-xs font-bold text-slate-400 uppercase tracking-widest">Actions</th>
      </tr>
      </thead>
      <tbody id="pat-tbody"></tbody>
    </table>

    <%-- ── Empty State ── --%>
    <div id="pat-empty" class="hidden py-20 text-center">
      <div class="inline-flex items-center justify-center size-16 rounded-2xl bg-slate-100 mb-4">
        <span class="material-symbols-outlined text-slate-400 text-[32px]">person_off</span>
      </div>
      <p class="text-slate-500 font-medium">No patients found</p>
      <p class="text-slate-400 text-xs mt-1">Try adjusting your search or filters</p>
    </div>
  </div>

  <p id="pat-count" class="text-xs text-slate-400 font-medium mt-4 px-1"></p>

</div>

<script>
  /**
   * index.jsp calls window.__pageInit() after injecting the HTML into the DOM.
   */
  window.__pageInit = function() {
    let activeFilter = 'all';
    let searchTerm   = '';

    // 1. Seed dynamic JSTL Data into JS (Using backticks `` to prevent syntax errors)
    const fetchedPatients = [
      <c:choose>
      <c:when test="${not empty patientList}">
      <c:forEach var="p" items="${patientList}" varStatus="loop">
      {
        id:         ${p.id},
        pid:        `${p.patientId}`,
        name:       `${p.name}`,
        age:        ${p.age},
        gender:     `${p.gender}`,
        phone:      `${p.phone}`,
        email:      `${p.email}`,
        lastVisit:  `${p.lastVisitDate}`,
        status:     `${p.status}`
      }<c:if test="${!loop.last}">,</c:if>
      </c:forEach>
      </c:when>
      </c:choose>
    ];

    // Override global patients if DB data exists, otherwise keep fallback data
    if (fetchedPatients.length > 0) {
      window.patients = fetchedPatients;
    } else if (!window.patients) {
      // Mock Patient Data Fallback
      window.patients = [
        {id: 1, name: 'Priya Sharma', pid: 'PT-001', age: 28, gender: 'Female', phone: '+91 98765-43210', email: 'priya@email.com', lastVisit: 'May 15, 2026', status: 'active'},
        {id: 2, name: 'Rohan Mehta', pid: 'PT-002', age: 45, gender: 'Male', phone: '+91 98765-11223', email: 'rohan.m@email.com', lastVisit: 'May 10, 2026', status: 'active'},
        {id: 3, name: 'Anjali Verma', pid: 'PT-003', age: 32, gender: 'Female', phone: '+91 99887-76655', email: 'anjali.v@email.com', lastVisit: 'May 12, 2026', status: 'inactive'},
        {id: 4, name: 'Karan Patel', pid: 'PT-004', age: 52, gender: 'Male', phone: '+91 91234-56789', email: 'karan@email.com', lastVisit: 'Apr 28, 2026', status: 'active'},
        {id: 5, name: 'Sneha Gupta', pid: 'PT-005', age: 24, gender: 'Female', phone: '+91 90000-11111', email: 'sneha@email.com', lastVisit: 'May 01, 2026', status: 'active'},
      ];
    }

    /* ── Stats ─────────────────────────────── */
    function renderStats() {
      const counts = {
        all: window.patients.length,
        active: window.patients.filter(p => p.status === 'active').length,
        inactive: window.patients.filter(p => p.status === 'inactive').length,
        new: 2 // You can update this to calculate dynamically if backend supports it
      };

      const statDefs = [
        {key:'all',    label:'Total Patients', icon:'groups',        bg:'bg-[#0052FF]',         shadow:'shadow-blue-500/20'},
        {key:'active', label:'Active Files',   icon:'person_check',  bg:'bg-[#70C1B3]',         shadow:'shadow-teal-400/20'},
        {key:'inactive', label:'Inactive',     icon:'person_remove', bg:'bg-slate-400',         shadow:'shadow-slate-300/30'},
        {key:'new',    label:'New (Week)',     icon:'fiber_new',     bg:'bg-[#f59e0b]',         shadow:'shadow-orange-400/20'},
      ];

      const container = document.getElementById('pat-stats');
      if (container) {
        container.innerHTML = statDefs.map(s => `
        <div class="${s.bg} ${s.shadow} shadow-lg p-5 rounded-2xl text-white flex items-center gap-4 transition-transform hover:-translate-y-0.5">
          <div class="bg-white/20 size-10 rounded-xl flex items-center justify-center flex-shrink-0">
            <span class="material-symbols-outlined text-[20px]" style="font-variation-settings:'FILL' 1">${s.icon}</span>
          </div>
          <div>
            <p class="text-white/70 text-[11px] font-semibold uppercase tracking-wider">${s.label}</p>
            <p class="text-xl font-black leading-tight">${counts[s.key]}</p>
          </div>
        </div>`).join('');
      }
    }

    /* ── Table Rendering ───────────────────── */
    function renderTable() {
      const list = window.patients.filter(p => {
        const matchFilter = activeFilter === 'all' || p.status === activeFilter;
        const q = searchTerm.toLowerCase();
        const matchSearch = !q || p.name.toLowerCase().includes(q) || p.pid.toLowerCase().includes(q);
        return matchFilter && matchSearch;
      });

      const tbody = document.getElementById('pat-tbody');
      const empty = document.getElementById('pat-empty');
      const count = document.getElementById('pat-count');

      if (!tbody) return;

      if (!list.length) {
        tbody.innerHTML = '';
        empty.classList.remove('hidden');
        count.textContent = '';
        return;
      }

      empty.classList.add('hidden');
      count.textContent = `Showing ${list.length} patient${list.length !== 1 ? 's' : ''}`;

      tbody.innerHTML = list.map(p => {
        // Fallback handlers to index.jsp logic
        const col = window.avatarColor ? window.avatarColor(p.name) : '#CBD5E1';
        const ini = window.initials ? window.initials(p.name) : p.name.charAt(0);
        const statusClass = p.status.toLowerCase() === 'active' ? 'bg-[#70C1B3]/10 text-teal-600' : 'bg-slate-100 text-slate-500';

        return `
      <tr class="border-b border-slate-50 last:border-0 hover:bg-slate-50/60 transition-colors">
        <td class="px-6 py-4">
          <div class="flex items-center gap-3">
            <div class="size-9 rounded-full flex items-center justify-center text-xs font-bold flex-shrink-0"
                 style="background:${col}22;color:${col}">${ini}</div>
            <div>
              <p class="font-semibold text-slate-900">${p.name}</p>
              <p class="text-[11px] text-slate-400 font-medium mt-0.5">${p.pid}</p>
            </div>
          </div>
        </td>
        <td class="px-6 py-4">
          <p class="font-semibold text-slate-800">${p.age} Yrs</p>
          <p class="text-[11px] text-slate-400 mt-0.5 font-medium">${p.gender}</p>
        </td>
        <td class="px-6 py-4">
          <p class="text-slate-700 font-medium">${p.phone}</p>
          <p class="text-[11px] text-slate-400 font-medium">${p.email}</p>
        </td>
        <td class="px-6 py-4 text-slate-600 font-medium">${p.lastVisit}</td>
        <td class="px-6 py-4">
          <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-[10px] font-bold uppercase tracking-wider ${statusClass}">
            <span class="size-1.5 rounded-full bg-current"></span>${p.status}
          </span>
        </td>
        <td class="px-6 py-4">
          <div class="flex items-center justify-end gap-2">
            <button class="p-2 text-slate-400 hover:text-[#0052FF] hover:bg-[#0052FF]/5 rounded-xl transition-all" title="View Records">
              <span class="material-symbols-outlined text-[20px]">visibility</span>
            </button>
            <button class="p-2 text-slate-400 hover:text-[#0052FF] hover:bg-[#0052FF]/5 rounded-xl transition-all" title="Book Appointment">
              <span class="material-symbols-outlined text-[20px]">add_task</span>
            </button>
            <button class="p-2 text-slate-400 hover:text-red-500 hover:bg-red-50 rounded-xl transition-all" title="Edit Profile">
              <span class="material-symbols-outlined text-[20px]">edit</span>
            </button>
          </div>
        </td>
      </tr>`;
      }).join('');
    }

    /* ── Events ─────────────────────────────── */
    document.querySelectorAll('.pat-filter-btn').forEach(btn => {
      btn.addEventListener('click', () => {
        activeFilter = btn.dataset.filter;
        document.querySelectorAll('.pat-filter-btn').forEach(b => {
          b.className = 'pat-filter-btn px-4 py-2 rounded-xl text-sm font-semibold transition-all text-slate-500 hover:text-slate-800';
        });
        btn.className = 'pat-filter-btn px-4 py-2 rounded-xl text-sm font-semibold transition-all bg-[#0052FF] text-white shadow';
        renderTable();
      });
    });

    const searchInput = document.getElementById('pat-search');
    if (searchInput) {
      searchInput.addEventListener('input', e => {
        searchTerm = e.target.value;
        renderTable();
      });
    }

    // Trigger initial render
    renderStats();
    renderTable();
  };
</script>