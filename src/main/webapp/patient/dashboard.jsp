<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta content="width=device-width, initial-scale=1.0" name="viewport">
<title>Patient Healthcare Overview Dashboard - Upachaar</title>
<script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
<script id="tailwind-config">
    tailwind.config = {
        darkMode: "class",
        theme: {
            extend: {
                colors: {
                    "primary": "#0052FF",
                    "brand-blue": "#0052FF",
                    "mint": "#70C1B3",
                    "off-white": "#F7FAFA",
                    "pending-blue": "#3b82f6",
                    "outstanding-orange": "#f59e0b",
                },
                fontFamily: {
                    "display": ["Inter", "sans-serif"],
                    "sans": ["Inter", "sans-serif"]
                },
                borderRadius: {
                    "DEFAULT": "0.25rem",
                    "lg": "0.5rem",
                    "xl": "1rem",
                    "2xl": "1.5rem",
                },
            },
        },
    }
</script>
<style type="text/tailwindcss">
    :root {
        --sidebar-width: 260px;
    }
    body {
        background-color: #F7FAFA;
    }
</style>
<style>
    body {
        min-height: max(884px, 100dvh);
    }
</style>
</head>
<body class="font-display text-slate-900 antialiased">

<%-- Example: String patientName = (String) session.getAttribute("patientName"); --%>
<%-- String patientId = (String) session.getAttribute("patientId"); --%>

<div class="flex h-screen w-full">

    <%-- ===== SIDEBAR ===== --%>
    <aside class="h-screen w-[260px] bg-[#0052FF] text-white shadow-2xl shadow-blue-500/20 flex flex-col py-6">
        <div class="px-8 mb-10">
            <h1 class="text-2xl font-black tracking-tight text-white uppercase">Upachaar</h1>
            <p class="text-[10px] uppercase tracking-widest text-white/60 font-bold">Patient Portal</p>
        </div>
        <nav class="flex-1 flex flex-col gap-1">
            <%-- Dashboard - ACTIVE --%>
            <a class="bg-white text-[#0052FF] rounded-full mx-4 px-4 py-3 font-semibold transition-all duration-200 flex items-center gap-3 shadow-lg shadow-black/10"
               href="dashboard.jsp">
                <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1;">dashboard</span>
                <span class="text-sm font-medium">Dashboard</span>
            </a>
            <%-- Appointments --%>
            <a class="text-white/70 hover:text-white mx-4 px-4 py-3 transition-all duration-200 hover:bg-white/10 rounded-full flex items-center gap-3"
               href="history.jsp">
                <span class="material-symbols-outlined">history</span>
                <span class="text-sm font-medium">Appointments</span>
            </a>
            <%-- Messages --%>
            <a class="text-white/70 hover:text-white mx-4 px-4 py-3 transition-all duration-200 hover:bg-white/10 rounded-full flex items-center gap-3"
               href="messages.jsp">
                <span class="material-symbols-outlined">chat</span>
                <span class="text-sm font-medium">Messages</span>
            </a>
            <%-- Settings --%>
            <a class="text-white/70 hover:text-white mx-4 px-4 py-3 transition-all duration-200 hover:bg-white/10 rounded-full flex items-center gap-3"
               href="settings.jsp">
                <span class="material-symbols-outlined">settings</span>
                <span class="text-sm font-medium">Settings</span>
            </a>
        </nav>

        <%-- Profile Section --%>
        <div class="mt-auto p-8 border-t border-white/10">
            <div class="flex items-center gap-4">
                <img alt="John Doe Profile"
                     class="w-12 h-12 rounded-full border-2 border-white/20 object-cover shadow-sm"
                     src="https://lh3.googleusercontent.com/aida-public/AB6AXuDV48gJehKcTQaA-tLOSd2OvWvj9d7PRLTCHa9ByLvLYu6KCt-7krRbexpoypL1VkcLJB6DspWvK4oXQJx8S3Q5uiTTehdR_8M-fZHHHxoYnhkIg1NCY-c3QYyaSOHOhq-b9s5HEsTjx-M_Vhu8hJ2IM0tohjD4py_Js6_ZN1AtCFeGUxx2bBfjfI-y8rwgteocwQ__wPViqVts95_wgeVc7s8wad54HoIY2wrxSF6PTiD0iLvnmwqOoV_OHAm2j6DjqvsTxFb3560">
                <div class="flex-1 min-w-0">
                    <p class="text-sm font-bold text-white truncate">John Doe</p>
                    <p class="text-xs text-white/60 truncate font-medium uppercase tracking-wider">Patient ID: #PT-9920</p>
                </div>
                <a href="logout.jsp" class="text-white/60 hover:text-white transition-colors">
                    <span class="material-symbols-outlined text-[20px]">logout</span>
                </a>
            </div>
        </div>
    </aside>

    <%-- ===== MAIN CONTENT ===== --%>
    <main class="flex-1 flex flex-col overflow-y-auto">

        <%-- Header --%>
        <header class="h-20 shrink-0 px-10 flex items-center justify-between">
            <div>
                <h1 class="text-2xl font-bold text-slate-900">Hello, John!</h1>
                <p class="text-sm text-slate-500">How are you feeling today?</p>
            </div>
            <div class="flex items-center gap-6">
                <button class="relative text-slate-400 hover:text-slate-600">
                    <span class="material-symbols-outlined text-[28px]">notifications</span>
                    <span class="absolute top-0 right-0 size-2 bg-red-500 rounded-full border-2 border-white"></span>
                </button>
                <div class="flex items-center gap-3 pl-6 border-l border-slate-200">
                    <div class="text-right">
                        <p class="text-sm font-bold text-slate-900 leading-none">John Doe</p>
                        <p class="text-xs text-slate-500">ID: #PT-9920</p>
                    </div>
                    <div class="size-10 rounded-full bg-brand-blue/10 flex items-center justify-center text-brand-blue overflow-hidden">
                        <span class="material-symbols-outlined text-3xl">account_circle</span>
                    </div>
                </div>
            </div>
        </header>

        <div class="flex-1 px-10 pb-10">

            <%-- ===== HEALTH SUMMARY CARDS ===== --%>
            <section class="mt-4 mb-8">
                <div class="flex items-center justify-between mb-6">
                    <h2 class="text-lg font-bold text-slate-800">Health Summary</h2>
                </div>
                <div class="grid grid-cols-4 gap-6">
                    <div class="bg-brand-blue p-6 rounded-2xl shadow-lg shadow-brand-blue/10 flex flex-col justify-between h-44 text-white group cursor-pointer hover:-translate-y-1 transition-transform">
                        <div class="bg-white/20 size-12 rounded-xl flex items-center justify-center">
                            <span class="material-symbols-outlined">calendar_today</span>
                        </div>
                        <div>
                            <p class="text-white/80 text-xs font-medium mb-1">Next Activity</p>
                            <p class="text-lg font-bold leading-tight">Upcoming Appointment</p>
                        </div>
                    </div>
                    <div class="bg-mint p-6 rounded-2xl shadow-lg shadow-mint/10 flex flex-col justify-between h-44 text-white group cursor-pointer hover:-translate-y-1 transition-transform">
                        <div class="bg-white/20 size-12 rounded-xl flex items-center justify-center">
                            <span class="material-symbols-outlined">prescriptions</span>
                        </div>
                        <div>
                            <p class="text-white/80 text-xs font-medium mb-1">Medication</p>
                            <p class="text-lg font-bold leading-tight">Recent Prescription</p>
                        </div>
                    </div>
                    <div class="bg-pending-blue p-6 rounded-2xl shadow-lg shadow-blue-500/10 flex flex-col justify-between h-44 text-white group cursor-pointer hover:-translate-y-1 transition-transform">
                        <div class="bg-white/20 size-12 rounded-xl flex items-center justify-center">
                            <span class="material-symbols-outlined">lab_research</span>
                        </div>
                        <div>
                            <p class="text-white/80 text-xs font-medium mb-1">Status</p>
                            <p class="text-lg font-bold leading-tight">Pending Lab Results</p>
                        </div>
                    </div>
                    <div class="bg-outstanding-orange p-6 rounded-2xl shadow-lg shadow-orange-500/10 flex flex-col justify-between h-44 text-white group cursor-pointer hover:-translate-y-1 transition-transform">
                        <div class="bg-white/20 size-12 rounded-xl flex items-center justify-center">
                            <span class="material-symbols-outlined">payments</span>
                        </div>
                        <div>
                            <p class="text-white/80 text-xs font-medium mb-1">Finance</p>
                            <p class="text-lg font-bold leading-tight">Outstanding Bills</p>
                        </div>
                    </div>
                </div>
            </section>

            <div class="grid grid-cols-12 gap-8">

                <%-- ===== NEXT APPOINTMENT ===== --%>
                <section class="col-span-8">
                    <div class="flex items-center justify-between mb-4">
                        <h2 class="text-lg font-bold text-slate-800">Next Appointment</h2>
                        <a href="schedule.jsp" class="text-brand-blue font-semibold text-sm hover:underline">View Schedule</a>
                    </div>
                    <div class="bg-white rounded-2xl p-8 shadow-sm border border-slate-100">
                        <div class="flex items-start justify-between">
                            <div class="flex gap-6">
                                <div class="bg-slate-50 size-24 rounded-2xl flex flex-col items-center justify-center border border-slate-100">
                                    <span class="text-brand-blue font-bold text-xs uppercase tracking-wider">Oct</span>
                                    <span class="text-slate-900 font-bold text-4xl">24</span>
                                </div>
                                <div>
                                    <div class="flex items-center gap-2 mb-1">
                                        <h3 class="text-2xl font-bold text-slate-900">Dr. Sarah Jenkins</h3>
                                        <span class="bg-mint/10 text-mint font-bold text-[10px] px-2 py-0.5 rounded uppercase">Confirmed</span>
                                    </div>
                                    <p class="text-slate-500 font-medium mb-4">Senior Cardiology Consultant &bull; St. Mary's Hospital</p>
                                    <div class="flex items-center gap-6">
                                        <div class="flex items-center gap-2 text-slate-600">
                                            <span class="material-symbols-outlined text-lg text-brand-blue">schedule</span>
                                            <span class="text-sm">10:30 AM (45 min)</span>
                                        </div>
                                        <div class="flex items-center gap-2 text-slate-600">
                                            <span class="material-symbols-outlined text-lg text-brand-blue">location_on</span>
                                            <span class="text-sm">Main Building, Room 402</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="text-right">
                                <div class="flex -space-x-3 mb-2">
                                    <div class="size-8 rounded-full border-2 border-white bg-slate-200"></div>
                                    <div class="size-8 rounded-full border-2 border-white bg-slate-300"></div>
                                </div>
                                <p class="text-[10px] text-slate-400 font-medium">Assistant: Emily Chen</p>
                            </div>
                        </div>
                        <div class="mt-10 flex gap-4">
                            <a href="appointmentDetails.jsp"
                               class="flex-1 bg-brand-blue text-white font-bold py-4 rounded-xl shadow-lg shadow-brand-blue/20 hover:opacity-90 transition-opacity text-center">
                                View Appointment Details
                            </a>
                            <a href="reschedule.jsp"
                               class="px-6 border border-slate-200 text-slate-600 font-bold py-4 rounded-xl hover:bg-slate-50 transition-colors text-center">
                                Reschedule
                            </a>
                        </div>
                    </div>
                </section>

                <%-- ===== MEDICAL RECORDS ===== --%>
                <section class="col-span-4">
                    <div class="flex items-center justify-between mb-4">
                        <h2 class="text-lg font-bold text-slate-800">Medical Records</h2>
                        <button class="text-slate-400">
                            <span class="material-symbols-outlined">filter_list</span>
                        </button>
                    </div>
                    <div class="bg-white rounded-2xl p-6 shadow-sm border border-slate-100">
                        <div class="space-y-6">

                            <%-- Record 1 --%>
                            <div class="relative pl-8 pb-6 border-l-2 border-slate-100 last:border-0 last:pb-0">
                                <div class="absolute -left-[9px] top-0 size-4 rounded-full bg-brand-blue ring-4 ring-white"></div>
                                <div>
                                    <p class="text-[10px] font-bold text-slate-400 uppercase tracking-widest mb-1">Oct 12, 2023</p>
                                    <h4 class="font-bold text-slate-900 mb-1">Blood Work Analysis</h4>
                                    <p class="text-xs text-slate-500 leading-relaxed">General Health Checkup results uploaded by Lab Central Diagnostic.</p>
                                    <a href="downloadRecord.jsp?id=1"
                                       class="mt-2 text-brand-blue text-[10px] font-bold flex items-center gap-1 hover:underline">
                                        <span class="material-symbols-outlined text-sm">download</span>
                                        DOWNLOAD PDF
                                    </a>
                                </div>
                            </div>

                            <%-- Record 2 --%>
                            <div class="relative pl-8 pb-6 border-l-2 border-slate-100 last:border-0 last:pb-0">
                                <div class="absolute -left-[9px] top-0 size-4 rounded-full bg-mint ring-4 ring-white"></div>
                                <div>
                                    <p class="text-[10px] font-bold text-slate-400 uppercase tracking-widest mb-1">Sep 28, 2023</p>
                                    <h4 class="font-bold text-slate-900 mb-1">Prescription Updated</h4>
                                    <p class="text-xs text-slate-500 leading-relaxed">Lisinopril 10mg - 30 Day Supply refilled at City Pharma.</p>
                                </div>
                            </div>

                            <%-- Record 3 --%>
                            <div class="relative pl-8 pb-0 border-l-2 border-slate-100 last:border-0 last:pb-0">
                                <div class="absolute -left-[9px] top-0 size-4 rounded-full bg-slate-300 ring-4 ring-white"></div>
                                <div>
                                    <p class="text-[10px] font-bold text-slate-400 uppercase tracking-widest mb-1">Sep 15, 2023</p>
                                    <h4 class="font-bold text-slate-900 mb-1">Radiology Report</h4>
                                    <p class="text-xs text-slate-500 leading-relaxed">Chest X-Ray imaging and final diagnosis report from St. Mary's.</p>
                                    <a href="viewImages.jsp?id=3"
                                       class="mt-2 text-brand-blue text-[10px] font-bold flex items-center gap-1 hover:underline">
                                        <span class="material-symbols-outlined text-sm">visibility</span>
                                        VIEW IMAGES
                                    </a>
                                </div>
                            </div>

                        </div>
                        <a href="medicalHistory.jsp"
                           class="block w-full mt-8 py-3 border-t border-slate-50 text-xs font-bold text-slate-400 hover:text-brand-blue transition-colors uppercase tracking-widest text-center">
                            View Full History
                        </a>
                    </div>
                </section>

            </div>
        </div>
    </main>
</div>

</body>
</html>
