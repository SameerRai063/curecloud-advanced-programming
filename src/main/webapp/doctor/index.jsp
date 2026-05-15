<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    // Example: fetch doctor info from session or DB
    // In a real app, replace these with session/service calls
    String doctorName    = "Dr. Aryan Kapoor";
    String doctorInitials= "AK";
    String doctorSpecialty = "Cardiologist";
    request.setAttribute("doctorName",     doctorName);
    request.setAttribute("doctorInitials", doctorInitials);
    request.setAttribute("doctorSpecialty",doctorSpecialty);
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta content="width=device-width, initial-scale=1.0" name="viewport">
<title>Doctor Dashboard — Upachaar</title>
<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
<script id="tailwind-config">
  tailwind.config = {
    darkMode: "class",
    theme: {
      extend: {
        colors: {
          "primary":            "#0052FF",
          "brand-blue":         "#0052FF",
          "mint":               "#70C1B3",
          "off-white":          "#F7FAFA",
          "pending-blue":       "#3b82f6",
          "outstanding-orange": "#f59e0b",
        },
        fontFamily: {
          "display": ["Inter", "sans-serif"],
          "sans":    ["Inter", "sans-serif"],
        },
        borderRadius: {
          "DEFAULT": "0.25rem",
          "lg":  "0.5rem",
          "xl":  "1rem",
          "2xl": "1.5rem",
        },
      },
    },
  }
</script>
<style type="text/tailwindcss">
  :root { --sidebar-width: 260px; }
  body  { background-color: #F7FAFA; }
  .material-symbols-outlined {
    font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
    vertical-align: middle;
  }
  #page-content { animation: fadeUp .22s ease both; }
  @keyframes fadeUp {
    from { opacity: 0; transform: translateY(10px); }
    to   { opacity: 1; transform: translateY(0); }
  }
  ::-webkit-scrollbar { width: 5px; }
  ::-webkit-scrollbar-track { background: transparent; }
  ::-webkit-scrollbar-thumb { background: #CBD5E1; border-radius: 99px; }
</style>
</head>
<body class="font-display text-slate-900 antialiased">
<div class="flex h-screen w-full overflow-hidden">

<!-- ═══════════════════════════════ SIDEBAR ═══════════════════════════════ -->
<aside class="h-screen w-[260px] bg-[#0052FF] text-white shadow-2xl shadow-blue-500/20 flex flex-col py-6 flex-shrink-0">
  <div class="px-8 mb-10">
    <h1 class="text-2xl font-black tracking-tight text-white uppercase">Upachaar</h1>
    <p class="text-[10px] uppercase tracking-widest text-white/60 font-bold">Clinical Suite</p>
  </div>
  <nav class="flex-1 flex flex-col gap-1 overflow-y-auto px-0">
    <a id="nav-dashboard"    class="bg-white text-[#0052FF] rounded-full mx-4 px-4 py-3 font-semibold transition-all duration-200 flex items-center gap-3 shadow-lg shadow-black/10 cursor-pointer" onclick="navigateTo('dashboard',this)">
      <span class="material-symbols-outlined" style="font-variation-settings:'FILL' 1">dashboard</span>
      <span class="text-sm font-medium">Dashboard</span>
    </a>
    <a id="nav-appointments" class="text-white/70 hover:text-white mx-4 px-4 py-3 transition-all duration-200 hover:bg-white/10 rounded-full flex items-center gap-3 cursor-pointer" onclick="navigateTo('appointments',this)">
      <span class="material-symbols-outlined">calendar_month</span>
      <span class="text-sm font-medium">Appointments</span>
    </a>
    <a id="nav-settings"     class="text-white/70 hover:text-white mx-4 px-4 py-3 transition-all duration-200 hover:bg-white/10 rounded-full flex items-center gap-3 cursor-pointer" onclick="navigateTo('settings',this)">
      <span class="material-symbols-outlined">settings</span>
      <span class="text-sm font-medium">Settings</span>
    </a>
  </nav>
  <!-- Profile -->
  <div class="mt-auto p-8 border-t border-white/10">
    <div class="flex items-center gap-4">
      <div class="w-12 h-12 rounded-full bg-white/20 ring-2 ring-white/30 flex items-center justify-center text-white font-bold text-base flex-shrink-0">
        ${doctorInitials}
      </div>
      <div class="flex-1 min-w-0">
        <p class="text-sm font-bold text-white truncate">${doctorName}</p>
        <p class="text-xs text-white/60 truncate font-medium uppercase tracking-wider">${doctorSpecialty}</p>
      </div>
      <%-- Logout button — point action to your logout servlet/URL --%>
      <form method="post" action="${pageContext.request.contextPath}/logout" style="margin:0">
        <button type="submit" class="text-white/60 hover:text-white transition-colors">
          <span class="material-symbols-outlined text-[20px]">logout</span>
        </button>
      </form>
    </div>
  </div>
</aside>

<!-- ═══════════════════════════════ MAIN ═══════════════════════════════ -->
<main class="flex-1 flex flex-col overflow-hidden">

  <!-- TOPBAR -->
  <header class="h-20 shrink-0 px-10 flex items-center justify-between">
    <div>
      <h1 class="text-2xl font-bold text-slate-900" id="page-title">Good morning, ${doctorName}!</h1>
      <p class="text-sm text-slate-500" id="page-sub">
        <%-- Date/appointment count can be set server-side or left to JS --%>
        Friday, May 15, 2026 &middot; 8 appointments today
      </p>
    </div>
    <div class="flex items-center gap-6">
      <button class="relative text-slate-400 hover:text-slate-600 transition-colors">
        <span class="material-symbols-outlined text-[28px]">notifications</span>
        <span class="absolute top-0 right-0 size-2 bg-red-500 rounded-full border-2 border-white"></span>
      </button>
      <div class="flex items-center gap-3 pl-6 border-l border-slate-200">
        <div class="text-right">
          <p class="text-sm font-bold text-slate-900 leading-none">${doctorName}</p>
          <p class="text-xs text-slate-500 mt-0.5">${doctorSpecialty}</p>
        </div>
        <div class="size-10 rounded-full bg-brand-blue/10 flex items-center justify-center text-brand-blue font-bold text-sm">
          ${doctorInitials}
        </div>
      </div>
    </div>
  </header>

  <!-- SCROLL AREA -->
  <div class="flex-1 overflow-y-auto px-10 pb-10" id="scroll-area">
    <div id="page-content">
      <!-- Page content loaded here via AJAX (see navigateTo) -->
    </div>
  </div>
</main>
</div>

<!-- ═══════════════════════════════ MODAL ═══════════════════════════════ -->
<div class="fixed inset-0 z-50 bg-black/40 backdrop-blur-sm hidden items-center justify-center p-4" id="confirm-modal">
  <div class="bg-white rounded-2xl shadow-2xl w-full max-w-md overflow-hidden">
    <div class="px-6 py-5 border-b border-slate-100 flex items-center justify-between">
      <h3 class="font-bold text-slate-900 text-lg" id="modal-title">Confirm Action</h3>
      <button onclick="closeModal()" class="text-slate-400 hover:text-slate-600 transition-colors">
        <span class="material-symbols-outlined">close</span>
      </button>
    </div>
    <div class="px-6 py-5">
      <p class="text-slate-600 text-sm leading-relaxed" id="modal-msg"></p>
    </div>
    <div class="px-6 py-4 border-t border-slate-100 flex justify-end gap-3">
      <button class="px-5 py-2.5 border border-slate-200 rounded-xl text-sm font-semibold text-slate-600 hover:bg-slate-50 transition-colors" onclick="closeModal()">Cancel</button>
      <button class="px-5 py-2.5 rounded-xl text-sm font-bold text-white transition-all" id="modal-confirm-btn" onclick="confirmModal()">Confirm</button>
    </div>
  </div>
</div>

<!-- ═══════════════════════════════ TOASTS ═══════════════════════════════ -->
<div class="fixed bottom-6 right-6 z-50 flex flex-col gap-3 pointer-events-none" id="toast-container"></div>

<script>
/* ── SHARED DATA ──────────────────────────── */
const COLORS = ['#0052FF','#70C1B3','#f59e0b','#f43f5e','#8B5CF6','#3b82f6','#EC4899'];
function initials(n){ return n.split(' ').map(w=>w[0]).join('').toUpperCase().slice(0,2); }
function avatarColor(n){ let h=0; for(let c of n) h=c.charCodeAt(0)+((h<<5)-h); return COLORS[Math.abs(h)%COLORS.length]; }

<%--
  NOTE: In a real JSP/Spring/Jakarta EE app, `window.appointments` and
  `window.reviews` would be populated from a Java backend (e.g. a Servlet,
  Spring MVC controller, or JSP scriptlet) rather than being hardcoded here.
  The JSON.stringify approach below keeps parity with the original HTML while
  making it easy to swap in server-side data later.
--%>
window.appointments = [
  {id:1, name:'Priya Sharma',  pid:'PT-001', date:'May 15, 2026', time:'09:00 AM', type:'Follow-up',       status:'upcoming'},
  {id:2, name:'Rohan Mehta',   pid:'PT-002', date:'May 15, 2026', time:'10:30 AM', type:'Consultation',    status:'pending'},
  {id:3, name:'Anjali Verma',  pid:'PT-003', date:'May 15, 2026', time:'12:00 PM', type:'Routine Checkup', status:'completed'},
  {id:4, name:'Karan Patel',   pid:'PT-004', date:'May 15, 2026', time:'02:15 PM', type:'ECG Review',      status:'upcoming'},
  {id:5, name:'Sneha Gupta',   pid:'PT-005', date:'May 15, 2026', time:'04:00 PM', type:'New Patient',     status:'cancelled'},
  {id:6, name:'Vikram Singh',  pid:'PT-006', date:'May 14, 2026', time:'11:00 AM', type:'Follow-up',       status:'completed'},
  {id:7, name:'Meera Joshi',   pid:'PT-007', date:'May 14, 2026', time:'03:00 PM', type:'Stress Test',     status:'completed'},
  {id:8, name:'Aditya Rao',    pid:'PT-008', date:'May 13, 2026', time:'09:30 AM', type:'Consultation',    status:'cancelled'},
  {id:9, name:'Pooja Nair',    pid:'PT-009', date:'May 13, 2026', time:'01:00 PM', type:'Echo Review',     status:'completed'},
  {id:10,name:'Suresh Kumar',  pid:'PT-010', date:'May 12, 2026', time:'10:00 AM', type:'Routine Checkup', status:'upcoming'},
];

window.reviews = [
  {name:'Rohan Mehta',    anon:false,rating:5,date:'May 14, 2026',comment:'Dr. Kapoor is an exceptional doctor. He took the time to explain everything clearly and made me feel at ease. The diagnosis was spot-on and the treatment has been very effective.',tags:['Clear Explanation','Great Listener','Punctual']},
  {name:'Patient #PT-003',anon:true, rating:5,date:'May 12, 2026',comment:'Excellent experience. Very thorough examination and the follow-up was well-structured. Highly recommended for anyone with cardiac concerns.',tags:['Thorough','Friendly','Professional']},
  {name:'Vikram Singh',   anon:false,rating:4,date:'May 11, 2026',comment:'Very knowledgeable and professional. The wait time was a bit long but the consultation itself was worth it. Would definitely come back.',tags:['Knowledgeable','Friendly']},
  {name:'Meera Joshi',    anon:false,rating:5,date:'May 9, 2026', comment:"I've been seeing Dr. Kapoor for two years now and the care has been consistently outstanding. He genuinely cares about his patients.",tags:['Consistent','Caring','Punctual']},
  {name:'Patient #PT-006',anon:true, rating:4,date:'May 7, 2026', comment:'Good consultation, explained the medication side effects well. Clinic is also very clean and organized.',tags:['Clean Facility','Clear Explanation']},
  {name:'Priya Sharma',   anon:false,rating:5,date:'May 5, 2026', comment:'Absolutely top-notch. Dr. Kapoor caught something my previous doctor missed entirely. Genuinely life-changing care.',tags:['Accurate Diagnosis','Great Listener']},
];

/* ── STATUS PILLS ─────────────────────────── */
const pillMap = {
  upcoming:  {bg:'bg-brand-blue/10 text-[#0052FF]',                label:'Upcoming'},
  pending:   {bg:'bg-outstanding-orange/10 text-outstanding-orange', label:'Pending'},
  completed: {bg:'bg-mint/10 text-teal-600',                        label:'Completed'},
  cancelled: {bg:'bg-slate-100 text-slate-500',                     label:'Cancelled'},
};
window.statusPill = function(s) {
  const p = pillMap[s] || {bg:'bg-slate-100 text-slate-500', label:s};
  return `<span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-[11px] font-bold ${p.bg}"><span class="size-1.5 rounded-full bg-current inline-block"></span>${p.label}</span>`;
};
window.initials    = initials;
window.avatarColor = avatarColor;

/* ── NAVIGATION ───────────────────────────── */
const pageInfo = {
  dashboard:    {title:'Good morning, ${doctorName}!', sub:'Friday, May 15, 2026 \u00b7 8 appointments today'},
  appointments: {title:'Appointments',                 sub:'Manage and track all patient visits'},
  settings:     {title:'Settings',                     sub:'Manage your profile and preferences'},
};

<%-- Page fragments are loaded via fetch; keep the same paths relative to context root --%>

const pageFiles = {
  dashboard:    'pages/dashboard.jsp',
  appointments: 'pages/appointments.jsp',
  settings:     'pages/settings.jsp',
};
let currentPage = null;

async function navigateTo(id, el) {
  if (currentPage === id) return;
  currentPage = id;

  // Update nav styles
  document.querySelectorAll('aside nav a').forEach(n => {
    n.className = 'text-white/70 hover:text-white mx-4 px-4 py-3 transition-all duration-200 hover:bg-white/10 rounded-full flex items-center gap-3 cursor-pointer';
    const icon = n.querySelector('.material-symbols-outlined');
    if (icon) icon.style.fontVariationSettings = "'FILL' 0, 'wght' 400";
  });
  el.className = 'bg-white text-[#0052FF] rounded-full mx-4 px-4 py-3 font-semibold transition-all duration-200 flex items-center gap-3 shadow-lg shadow-black/10 cursor-pointer';
  const icon = el.querySelector('.material-symbols-outlined');
  if (icon) icon.style.fontVariationSettings = "'FILL' 1, 'wght' 500";

  // Update header
  document.getElementById('page-title').textContent = pageInfo[id].title;
  document.getElementById('page-sub').textContent   = pageInfo[id].sub;

  // Load page content
  try {
    const res  = await fetch(pageFiles[id]);
    const html = await res.text();
    const container = document.getElementById('page-content');
    container.style.animation = 'none';

    // Clear container and parse incoming HTML
    container.innerHTML = '';
    window.__pageInit = null;
    const temp = document.createElement('div');
    temp.innerHTML = html;

    // Re-create script tags so the browser actually executes them
    temp.querySelectorAll('script').forEach(oldScript => {
      const newScript = document.createElement('script');
      newScript.textContent = oldScript.textContent;
      oldScript.replaceWith(newScript);
    });

    container.appendChild(temp);

    // Re-trigger animation
    void container.offsetWidth;
    container.style.animation = '';

    // Scroll to top
    document.getElementById('scroll-area').scrollTop = 0;

    // Run page init if defined
    if (window.__pageInit) window.__pageInit();
  } catch(e) {
    document.getElementById('page-content').innerHTML =
      `<div class="mt-20 text-center text-slate-400">Failed to load page. Make sure pages/ JSP files are present.</div>`;
  }
}

/* ── MODAL ────────────────────────────────── */
let pendingAction = null;
window.changeStatus = function(id, newStatus) {
  const a = window.appointments.find(x => x.id === id);
  pendingAction = {id, newStatus};
  const isComplete = newStatus === 'completed';
  document.getElementById('modal-title').textContent = isComplete ? 'Mark as Completed' : 'Cancel Appointment';
  document.getElementById('modal-msg').textContent   = isComplete
    ? `Mark ${a.name}'s appointment on ${a.date} at ${a.time} as completed?`
    : `Are you sure you want to cancel ${a.name}'s appointment on ${a.date}? This cannot be undone.`;
  const btn = document.getElementById('modal-confirm-btn');
  btn.textContent = isComplete ? 'Mark Completed' : 'Cancel Appointment';
  btn.className   = `px-5 py-2.5 rounded-xl text-sm font-bold text-white transition-all ${isComplete ? 'bg-mint hover:opacity-90' : 'bg-red-400 hover:opacity-90'}`;
  document.getElementById('confirm-modal').classList.remove('hidden');
  document.getElementById('confirm-modal').classList.add('flex');
};
window.confirmModal = function confirmModal() {
  if (!pendingAction) return;
  const {id, newStatus} = pendingAction;
  const a = window.appointments.find(x => x.id === id);
  a.status = newStatus;
  closeModal();
  if (window.__apptRender) window.__apptRender();
  toast(newStatus === 'completed' ? `${a.name}'s appointment marked completed` : `Appointment with ${a.name} cancelled`);
};
window.closeModal = function closeModal() {
  document.getElementById('confirm-modal').classList.add('hidden');
  document.getElementById('confirm-modal').classList.remove('flex');
  pendingAction = null;
};

/* ── TOAST ────────────────────────────────── */
window.toast = function toast(msg) {
  const c  = document.getElementById('toast-container');
  const el = document.createElement('div');
  el.className = 'flex items-center gap-3 bg-slate-900 text-white px-5 py-3 rounded-2xl shadow-2xl text-sm font-medium min-w-[260px] border-l-4 border-brand-blue pointer-events-auto';
  el.innerHTML = `<span class="material-symbols-outlined text-[#0052FF] text-[18px]" style="font-variation-settings:'FILL' 1">check_circle</span><span>${msg}</span>`;
  c.appendChild(el);
  setTimeout(() => el.remove(), 3500);
};

/* ── BOOT ─────────────────────────────────── */
navigateTo('dashboard', document.getElementById('nav-dashboard'));
</script>
</body>
</html>
