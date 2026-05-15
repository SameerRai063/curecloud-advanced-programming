<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>Receptionist Dashboard — Upachaar</title>

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

    <aside class="h-screen w-[260px] bg-[#0052FF] text-white shadow-2xl shadow-blue-500/20 flex flex-col py-6 flex-shrink-0">
        <div class="px-8 mb-10">
            <h1 class="text-2xl font-black tracking-tight text-white uppercase">Upachaar</h1>
            <p class="text-[10px] uppercase tracking-widest text-white/60 font-bold">Front Desk Suite</p>
        </div>
        <nav class="flex-1 flex flex-col gap-1 overflow-y-auto px-0">
            <a id="nav-dashboard" class="bg-white text-[#0052FF] rounded-full mx-4 px-4 py-3 font-semibold transition-all duration-200 flex items-center gap-3 shadow-lg shadow-black/10 cursor-pointer" onclick="navigateTo('dashboard',this)">
                <span class="material-symbols-outlined" style="font-variation-settings:'FILL' 1">dashboard</span>
                <span class="text-sm font-medium">Dashboard</span>
            </a>
            <a id="nav-doctors" class="text-white/70 hover:text-white mx-4 px-4 py-3 transition-all duration-200 hover:bg-white/10 rounded-full flex items-center gap-3 cursor-pointer" onclick="navigateTo('doctors',this)">
                <span class="material-symbols-outlined">medical_services</span>
                <span class="text-sm font-medium">Doctors</span>
            </a>
            <a id="nav-patients" class="text-white/70 hover:text-white mx-4 px-4 py-3 transition-all duration-200 hover:bg-white/10 rounded-full flex items-center gap-3 cursor-pointer" onclick="navigateTo('patients',this)">
                <span class="material-symbols-outlined">groups</span>
                <span class="text-sm font-medium">Patients</span>
            </a>
            <a id="nav-appointments" class="text-white/70 hover:text-white mx-4 px-4 py-3 transition-all duration-200 hover:bg-white/10 rounded-full flex items-center gap-3 cursor-pointer" onclick="navigateTo('appointments',this)">
                <span class="material-symbols-outlined">calendar_month</span>
                <span class="text-sm font-medium">Appointments</span>
            </a>
            <a id="nav-messages" class="text-white/70 hover:text-white mx-4 px-4 py-3 transition-all duration-200 hover:bg-white/10 rounded-full flex items-center gap-3 cursor-pointer" onclick="navigateTo('messages',this)">
                <span class="material-symbols-outlined">chat</span>
                <span class="text-sm font-medium">Messages</span>
            </a>
            <a id="nav-reviews" class="text-white/70 hover:text-white mx-4 px-4 py-3 transition-all duration-200 hover:bg-white/10 rounded-full flex items-center gap-3 cursor-pointer" onclick="navigateTo('reviews',this)">
                <span class="material-symbols-outlined">reviews</span>
                <span class="text-sm font-medium">Reviews</span>
            </a>
            <a id="nav-settings" class="text-white/70 hover:text-white mx-4 px-4 py-3 transition-all duration-200 hover:bg-white/10 rounded-full flex items-center gap-3 cursor-pointer" onclick="navigateTo('settings',this)">
                <span class="material-symbols-outlined">settings</span>
                <span class="text-sm font-medium">Settings</span>
            </a>
        </nav>

        <div class="mt-auto p-8 border-t border-white/10">
            <div class="flex items-center gap-4">
                <div class="w-12 h-12 rounded-full bg-white/20 ring-2 ring-white/30 flex items-center justify-center text-white font-bold text-base flex-shrink-0">PS</div>
                <div class="flex-1 min-w-0">
                    <p class="text-sm font-bold text-white truncate">Priya Singh</p>
                    <p class="text-xs text-white/60 truncate font-medium uppercase tracking-wider">Lead Receptionist</p>
                </div>
                <button class="text-white/60 hover:text-white transition-colors">
                    <span class="material-symbols-outlined text-[20px]">logout</span>
                </button>
            </div>
        </div>
    </aside>

    <main class="flex-1 flex flex-col overflow-hidden">
        <header class="h-20 shrink-0 px-10 flex items-center justify-between bg-white border-b border-slate-100 shadow-sm">
            <div>
                <h1 class="text-2xl font-bold text-slate-900" id="page-title">Good morning, Priya!</h1>
                <p class="text-sm text-slate-500" id="page-sub">Friday, May 15, 2026 · Front Desk Overview</p>
            </div>
            <div class="flex items-center gap-6">
                <button class="relative text-slate-400 hover:text-slate-600 transition-colors">
                    <span class="material-symbols-outlined text-[28px]">notifications</span>
                    <span class="absolute top-0 right-0 size-2 bg-red-500 rounded-full border-2 border-white"></span>
                </button>
                <div class="flex items-center gap-3 pl-6 border-l border-slate-200">
                    <div class="text-right">
                        <p class="text-sm font-bold text-slate-900 leading-none">Priya Singh</p>
                        <p class="text-xs text-slate-500 mt-0.5">Lead Receptionist</p>
                    </div>
                    <div class="size-10 rounded-full bg-brand-blue/10 flex items-center justify-center text-brand-blue font-bold text-sm">PS</div>
                </div>
            </div>
        </header>

        <div class="flex-1 overflow-y-auto px-10 pb-10" id="scroll-area">
            <div id="page-content"></div>
        </div>
    </main>
</div>

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

<div class="fixed bottom-6 right-6 z-50 flex flex-col gap-3 pointer-events-none" id="toast-container"></div>

<script>
    /* ── DATA ── */
    const COLORS = ['#0052FF','#70C1B3','#f59e0b','#f43f5e','#8B5CF6','#3b82f6','#EC4899'];
    function initials(n){ return n.split(' ').map(w=>w[0]).join('').toUpperCase().slice(0,2); }
    function avatarColor(n){ let h=0; for(let c of n) h=c.charCodeAt(0)+((h<<5)-h); return COLORS[Math.abs(h)%COLORS.length]; }

    window.appointments = [
        {id:1, name:'Priya Sharma',  pid:'PT-001', doctor:'Dr. A. Kapoor', date:'May 15, 2026', time:'09:00 AM', type:'Follow-up',       status:'upcoming'},
        {id:2, name:'Rohan Mehta',   pid:'PT-002', doctor:'Dr. A. Kapoor', date:'May 15, 2026', time:'10:30 AM', type:'Consultation',    status:'pending'},
        {id:3, name:'Anjali Verma',  pid:'PT-003', doctor:'Dr. S. Reddy',  date:'May 15, 2026', time:'12:00 PM', type:'Routine Checkup', status:'completed'},
        {id:4, name:'Karan Patel',   pid:'PT-004', doctor:'Dr. S. Reddy',  date:'May 15, 2026', time:'02:15 PM', type:'Report Review',   status:'upcoming'},
    ];

    /* ── NAVIGATION ── */
    const pageFiles = {
        dashboard:    'pages/dashboard.jsp',
        doctors:      'pages/doctors.jsp',
        patients:     'pages/patients.jsp',
        appointments: 'pages/appointments.jsp',
        messages:     'pages/messages.jsp',
        reviews:      'pages/reviews.jsp',
        settings:     'pages/settings.jsp',
    };

    const pageInfo = {
        dashboard:   {title:'Good morning, Priya!',      sub:'Friday, May 15, 2026 · Front Desk Overview'},
        doctors:     {title:'Doctors Roster',            sub:'Manage schedules and availability'},
        patients:    {title:'Patient Directory',         sub:'View and update patient records'},
        appointments:{title:'Master Schedule',           sub:'Manage and track all clinic visits'},
        messages:    {title:'Messages & Inquiries',      sub:'Patient communication and internal notes'},
        reviews:     {title:'Patient Reviews',           sub:'Monitor feedback and clinic ratings'},
        settings:    {title:'Front Desk Settings',       sub:'Manage your workspace and system preferences'},
    };

    let currentPage = null;

    async function navigateTo(id, el) {
        if (currentPage === id) return;
        currentPage = id;

        document.querySelectorAll('aside nav a').forEach(n => {
            n.className = 'text-white/70 hover:text-white mx-4 px-4 py-3 transition-all duration-200 hover:bg-white/10 rounded-full flex items-center gap-3 cursor-pointer';
            const icon = n.querySelector('.material-symbols-outlined');
            if (icon) icon.style.fontVariationSettings = "'FILL' 0, 'wght' 400";
        });
        el.className = 'bg-white text-[#0052FF] rounded-full mx-4 px-4 py-3 font-semibold transition-all duration-200 flex items-center gap-3 shadow-lg shadow-black/10 cursor-pointer';
        const icon = el.querySelector('.material-symbols-outlined');
        if (icon) icon.style.fontVariationSettings = "'FILL' 1, 'wght' 500";

        document.getElementById('page-title').textContent = pageInfo[id].title;
        document.getElementById('page-sub').textContent   = pageInfo[id].sub;

        try {
            const res  = await fetch(pageFiles[id]);
            const html = await res.text();
            const container = document.getElementById('page-content');
            container.style.animation = 'none';
            container.innerHTML = '';

            const temp = document.createElement('div');
            temp.innerHTML = html;
            temp.querySelectorAll('script').forEach(oldScript => {
                const newScript = document.createElement('script');
                newScript.textContent = oldScript.textContent;
                oldScript.replaceWith(newScript);
            });

            container.appendChild(temp);
            void container.offsetWidth;
            container.style.animation = '';
            document.getElementById('scroll-area').scrollTop = 0;
            if (window.__pageInit) window.__pageInit();
        } catch(e) {
            document.getElementById('page-content').innerHTML = `<div class="mt-20 text-center text-slate-400">Error loading ${pageFiles[id]}</div>`;
        }
    }

    /* ── MODALS & TOASTS ── */
    function closeModal() {
        document.getElementById('confirm-modal').classList.add('hidden');
        document.getElementById('confirm-modal').classList.remove('flex');
    }

    function toast(msg) {
        const c = document.getElementById('toast-container');
        const el = document.createElement('div');
        el.className = 'flex items-center gap-3 bg-slate-900 text-white px-5 py-3 rounded-2xl shadow-2xl text-sm font-medium border-l-4 border-brand-blue pointer-events-auto';
        el.innerHTML = `<span class="material-symbols-outlined text-primary text-[18px]">check_circle</span><span>${msg}</span>`;
        c.appendChild(el);
        setTimeout(() => el.remove(), 3500);
    }

    // Initial Load
    navigateTo('dashboard', document.getElementById('nav-dashboard'));
</script>
</body>
</html>