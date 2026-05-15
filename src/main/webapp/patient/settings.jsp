<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>Settings - Upachaar Patient Portal</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
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
            }
        }
    </script>
    <style type="text/tailwindcss">
        :root { --sidebar-width: 260px; }
        body { background-color: #F7FAFA; }
    </style>
    <style>
        body { min-height: max(884px, 100dvh); font-family: 'Inter', sans-serif; }
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
            vertical-align: middle;
        }
        .tab-btn.active {
            background: #0052FF;
            color: #fff;
            box-shadow: 0 4px 14px rgba(0,82,255,0.25);
        }
        .tab-btn:not(.active):hover {
            background: #EEF3FF;
            color: #0052FF;
        }
        .tab-panel { display: none; }
        .tab-panel.active { display: block; }

        /* toggle switch */
        .toggle-checkbox:checked + .toggle-track { background-color: #0052FF; }
        .toggle-checkbox:checked + .toggle-track .toggle-thumb { transform: translateX(20px); }
        .toggle-track { transition: background 0.2s; }
        .toggle-thumb { transition: transform 0.2s; }

        /* input focus ring */
        input:focus, select:focus, textarea:focus {
            outline: none;
            border-color: #0052FF;
            box-shadow: 0 0 0 3px rgba(0,82,255,0.12);
        }

        /* fade-in on load */
        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(12px); }
            to   { opacity: 1; transform: translateY(0); }
        }
        .fade-up { animation: fadeUp 0.35s ease both; }
        .fade-up-1 { animation-delay: 0.05s; }
        .fade-up-2 { animation-delay: 0.10s; }
        .fade-up-3 { animation-delay: 0.15s; }

        /* save toast */
        #toast { transition: opacity 0.3s, transform 0.3s; }
        #toast.show { opacity: 1 !important; transform: translateY(0) !important; }
    </style>
</head>
<body class="text-slate-900 antialiased">

<div class="flex h-screen w-full">

    <%-- ══════════════════════════════════════
         SIDEBAR
    ══════════════════════════════════════ --%>
    <aside class="h-screen w-[260px] bg-[#0052FF] text-white shadow-2xl shadow-blue-500/20 flex flex-col py-6 fixed top-0 left-0 z-50">
        <div class="px-8 mb-10">
            <h1 class="text-2xl font-black tracking-tight text-white uppercase">Upachaar</h1>
            <p class="text-[10px] uppercase tracking-widest text-white/60 font-bold">Patient Portal</p>
        </div>
        <nav class="flex-1 flex flex-col gap-1">
            <a class="text-white/70 hover:text-white mx-4 px-4 py-3 transition-all duration-200 hover:bg-white/10 rounded-full flex items-center gap-3" href="dashboard.jsp">
                <span class="material-symbols-outlined">dashboard</span>
                <span class="text-sm font-medium">Dashboard</span>
            </a>
            <a class="text-white/70 hover:text-white mx-4 px-4 py-3 transition-all duration-200 hover:bg-white/10 rounded-full flex items-center gap-3" href="history.jsp">
                <span class="material-symbols-outlined">history</span>
                <span class="text-sm font-medium">Appointments</span>
            </a>
            <a class="text-white/70 hover:text-white mx-4 px-4 py-3 transition-all duration-200 hover:bg-white/10 rounded-full flex items-center gap-3" href="messages.jsp">
                <span class="material-symbols-outlined">chat</span>
                <span class="text-sm font-medium">Messages</span>
            </a>
            <%-- Settings - ACTIVE --%>
            <a class="bg-white text-[#0052FF] rounded-full mx-4 px-4 py-3 font-semibold transition-all duration-200 flex items-center gap-3 shadow-lg shadow-black/10" href="settings.jsp">
                <span class="material-symbols-outlined" style="font-variation-settings:'FILL' 1;">settings</span>
                <span class="text-sm font-medium">Settings</span>
            </a>
        </nav>
        <%-- Profile --%>
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

    <%-- ══════════════════════════════════════
         MAIN
    ══════════════════════════════════════ --%>
    <main class="flex-1 ml-[260px] flex flex-col overflow-y-auto">

        <%-- Top bar --%>
        <header class="h-20 shrink-0 px-10 flex items-center justify-between bg-[#F7FAFA] sticky top-0 z-30 border-b border-slate-100">
            <div>
                <h1 class="text-2xl font-bold text-slate-900">Settings</h1>
                <p class="text-sm text-slate-500">Manage your account and preferences</p>
            </div>
            <div class="flex items-center gap-6">
                <button class="relative text-slate-400 hover:text-slate-600">
                    <span class="material-symbols-outlined text-[28px]">notifications</span>
                    <span class="absolute top-0 right-0 size-2 bg-red-500 rounded-full border-2 border-[#F7FAFA]"></span>
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

        <div class="flex-1 px-10 py-8 max-w-5xl w-full mx-auto">

            <%-- Tab nav --%>
            <div class="flex gap-2 mb-8 bg-white rounded-2xl p-1.5 shadow-sm border border-slate-100 w-fit fade-up">
                <button class="tab-btn active text-sm font-semibold px-5 py-2.5 rounded-xl transition-all flex items-center gap-2" data-tab="profile">
                    <span class="material-symbols-outlined text-[18px]">person</span> Profile
                </button>
                <button class="tab-btn text-sm font-semibold text-slate-500 px-5 py-2.5 rounded-xl transition-all flex items-center gap-2" data-tab="security">
                    <span class="material-symbols-outlined text-[18px]">lock</span> Security
                </button>
            </div>

            <%-- ══ PROFILE TAB ══ --%>
            <div id="tab-profile" class="tab-panel active space-y-6">

                <%-- Profile hero card --%>
                <div class="bg-white rounded-2xl shadow-sm border border-slate-100 overflow-hidden fade-up fade-up-1">
                    <div class="h-28 bg-gradient-to-r from-[#0052FF] to-blue-400 relative">
                        <div class="absolute inset-0 opacity-10"
                             style="background-image: radial-gradient(circle at 20% 50%, white 1px, transparent 1px),
                                    radial-gradient(circle at 80% 20%, white 1px, transparent 1px);
                                    background-size: 40px 40px;">
                        </div>
                    </div>
                    <div class="px-8 pb-6 flex flex-col sm:flex-row items-end gap-5 -mt-10 relative z-10">
                        <div class="relative group shrink-0">
                            <img id="profilePreview"
                                 alt="John Doe"
                                 class="w-24 h-24 rounded-2xl object-cover border-4 border-white shadow-xl"
                                 src="https://lh3.googleusercontent.com/aida-public/AB6AXuDV48gJehKcTQaA-tLOSd2OvWvj9d7PRLTCHa9ByLvLYu6KCt-7krRbexpoypL1VkcLJB6DspWvK4oXQJx8S3Q5uiTTehdR_8M-fZHHHxoYnhkIg1NCY-c3QYyaSOHOhq-b9s5HEsTjx-M_Vhu8hJ2IM0tohjD4py_Js6_ZN1AtCFeGUxx2bBfjfI-y8rwgteocwQ__wPViqVts95_wgeVc7s8wad54HoIY2wrxSF6PTiD0iLvnmwqOoV_OHAm2j6DjqvsTxFb3560">
                        </div>
                        <div class="flex-1 pb-1">
                            <div class="flex flex-wrap items-center gap-3">
                                <h2 class="text-xl font-bold text-slate-900">John Doe</h2>
                                <span class="bg-mint/10 text-mint font-bold text-[10px] px-2.5 py-1 rounded-full uppercase tracking-wider flex items-center gap-1">
                                    <span class="w-1.5 h-1.5 bg-mint rounded-full"></span> Active
                                </span>
                            </div>
                            <p class="text-slate-500 text-sm mt-0.5">Patient ID: #PT-9920 &nbsp;&bull;&nbsp; St. Mary's Hospital</p>
                        </div>
                        <div class="pb-1 flex items-center gap-3 text-sm text-slate-500">
                            <span class="material-symbols-outlined text-brand-blue text-[18px]">water_drop</span>
                            <span class="font-semibold text-slate-700" id="bloodGroupDisplay">B+</span>
                        </div>
                    </div>
                </div>

                <%-- Update form --%>
                <div class="bg-white rounded-2xl shadow-sm border border-slate-100 p-8 fade-up fade-up-2">
                    <h3 class="text-base font-bold text-slate-800 mb-6 flex items-center gap-2">
                        <span class="material-symbols-outlined text-brand-blue">edit_note</span>
                        Update Profile Information
                    </h3>

                    <form action="updatePatient.jsp" method="POST" class="space-y-6" id="profileForm">
                        <%-- Hidden patient ID --%>
                        <input type="hidden" name="targetUserId" value="9920">

                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">

                            <%-- Full Name --%>
                            <div class="space-y-1.5">
                                <label class="text-xs font-bold text-slate-500 uppercase tracking-wider" for="name">Full Name</label>
                                <div class="relative">
                                    <span class="absolute left-3.5 top-1/2 -translate-y-1/2 material-symbols-outlined text-slate-400 text-[18px]">person</span>
                                    <input id="name" name="name" type="text" value="John Doe" required
                                           class="w-full pl-10 pr-4 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm font-medium text-slate-900 transition-all">
                                </div>
                            </div>

                            <%-- Phone --%>
                            <div class="space-y-1.5">
                                <label class="text-xs font-bold text-slate-500 uppercase tracking-wider" for="phone">Phone Number</label>
                                <div class="relative">
                                    <span class="absolute left-3.5 top-1/2 -translate-y-1/2 material-symbols-outlined text-slate-400 text-[18px]">call</span>
                                    <input id="phone" name="phone" type="tel" value="+1 (555) 012-3456" required
                                           class="w-full pl-10 pr-4 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm font-medium text-slate-900 transition-all">
                                </div>
                            </div>

                            <%-- Gender --%>
                            <div class="space-y-1.5">
                                <label class="text-xs font-bold text-slate-500 uppercase tracking-wider" for="gender">Gender</label>
                                <div class="relative">
                                    <span class="absolute left-3.5 top-1/2 -translate-y-1/2 material-symbols-outlined text-slate-400 text-[18px]">wc</span>
                                    <select id="gender" name="gender"
                                            class="w-full pl-10 pr-4 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm font-medium text-slate-900 appearance-none transition-all">
                                        <option value="Male" selected>Male</option>
                                        <option value="Female">Female</option>
                                        <option value="Other">Other</option>
                                        <option value="Prefer not to say">Prefer not to say</option>
                                    </select>
                                    <span class="absolute right-3.5 top-1/2 -translate-y-1/2 material-symbols-outlined text-slate-400 text-[18px] pointer-events-none">expand_more</span>
                                </div>
                            </div>

                            <%-- Blood Group --%>
                            <div class="space-y-1.5">
                                <label class="text-xs font-bold text-slate-500 uppercase tracking-wider" for="bloodGroup">Blood Group</label>
                                <div class="relative">
                                    <span class="absolute left-3.5 top-1/2 -translate-y-1/2 material-symbols-outlined text-red-400 text-[18px]">water_drop</span>
                                    <select id="bloodGroup" name="bloodGroup"
                                            class="w-full pl-10 pr-4 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm font-medium text-slate-900 appearance-none transition-all">
                                        <option>A+</option>
                                        <option>A-</option>
                                        <option selected>B+</option>
                                        <option>B-</option>
                                        <option>AB+</option>
                                        <option>AB-</option>
                                        <option>O+</option>
                                        <option>O-</option>
                                    </select>
                                    <span class="absolute right-3.5 top-1/2 -translate-y-1/2 material-symbols-outlined text-slate-400 text-[18px] pointer-events-none">expand_more</span>
                                </div>
                            </div>

                            <%-- Address (full width) --%>
                            <div class="space-y-1.5 md:col-span-2">
                                <label class="text-xs font-bold text-slate-500 uppercase tracking-wider" for="address">Address</label>
                                <div class="relative">
                                    <span class="absolute left-3.5 top-3.5 material-symbols-outlined text-slate-400 text-[18px]">location_on</span>
                                    <textarea id="address" name="address" rows="2"
                                              class="w-full pl-10 pr-4 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm font-medium text-slate-900 resize-none transition-all">123 Main Street, Metro City, MC 10001</textarea>
                                </div>
                            </div>

                        </div>

                        <%-- isActive toggle --%>
                        <div class="flex items-center justify-between bg-slate-50 rounded-xl px-5 py-4 border border-slate-200">
                            <div>
                                <p class="text-sm font-bold text-slate-800">Account Active Status</p>
                                <p class="text-xs text-slate-500 mt-0.5">Deactivating will restrict access to the patient portal</p>
                            </div>
                            <label class="relative inline-flex items-center cursor-pointer select-none">
                                <input type="checkbox" id="isActiveCheckbox" class="toggle-checkbox sr-only" checked>
                                <div class="toggle-track w-[44px] h-[24px] bg-slate-300 rounded-full relative">
                                    <div class="toggle-thumb absolute top-[3px] left-[3px] w-[18px] h-[18px] bg-white rounded-full shadow-md"></div>
                                </div>
                                <input type="hidden" name="isActive" id="isActiveValue" value="true">
                                <span class="ml-3 text-sm font-bold text-slate-700" id="isActiveLabel">Active</span>
                            </label>
                        </div>

                        <%-- Submit --%>
                        <div class="flex justify-end pt-2">
                            <button type="submit"
                                    class="bg-brand-blue text-white font-bold px-8 py-3.5 rounded-xl shadow-lg shadow-brand-blue/25 hover:opacity-90 active:scale-95 transition-all flex items-center gap-2">
                                <span class="material-symbols-outlined text-[20px]">save</span>
                                Save Changes
                            </button>
                        </div>
                    </form>
                </div>

            </div><%-- /profile tab --%>

            <%-- ══ SECURITY TAB ══ --%>
            <div id="tab-security" class="tab-panel space-y-6">

                <div class="bg-white rounded-2xl shadow-sm border border-slate-100 p-8 fade-up">
                    <h3 class="text-base font-bold text-slate-800 mb-6 flex items-center gap-2">
                        <span class="material-symbols-outlined text-brand-blue">lock_reset</span>
                        Change Password
                    </h3>
                    <form class="space-y-5" onsubmit="handlePasswordChange(event)">
                        <div class="space-y-1.5">
                            <label class="text-xs font-bold text-slate-500 uppercase tracking-wider">Current Password</label>
                            <div class="relative">
                                <span class="absolute left-3.5 top-1/2 -translate-y-1/2 material-symbols-outlined text-slate-400 text-[18px]">lock</span>
                                <input type="password" placeholder="&bull;&bull;&bull;&bull;&bull;&bull;&bull;&bull;"
                                       class="w-full pl-10 pr-4 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm font-medium text-slate-900 transition-all">
                            </div>
                        </div>
                        <div class="space-y-1.5">
                            <label class="text-xs font-bold text-slate-500 uppercase tracking-wider">New Password</label>
                            <div class="relative">
                                <span class="absolute left-3.5 top-1/2 -translate-y-1/2 material-symbols-outlined text-slate-400 text-[18px]">lock_open</span>
                                <input type="password" placeholder="&bull;&bull;&bull;&bull;&bull;&bull;&bull;&bull;"
                                       class="w-full pl-10 pr-4 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm font-medium text-slate-900 transition-all">
                            </div>
                        </div>
                        <div class="space-y-1.5">
                            <label class="text-xs font-bold text-slate-500 uppercase tracking-wider">Confirm New Password</label>
                            <div class="relative">
                                <span class="absolute left-3.5 top-1/2 -translate-y-1/2 material-symbols-outlined text-slate-400 text-[18px]">verified_user</span>
                                <input type="password" placeholder="&bull;&bull;&bull;&bull;&bull;&bull;&bull;&bull;"
                                       class="w-full pl-10 pr-4 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm font-medium text-slate-900 transition-all">
                            </div>
                        </div>
                        <div class="flex justify-end pt-2">
                            <button type="submit"
                                    class="bg-brand-blue text-white font-bold px-8 py-3.5 rounded-xl shadow-lg shadow-brand-blue/25 hover:opacity-90 active:scale-95 transition-all flex items-center gap-2">
                                <span class="material-symbols-outlined text-[20px]">lock_reset</span>
                                Update Password
                            </button>
                        </div>
                    </form>
                </div>

                <%-- Access level info --%>
                <div class="bg-blue-50 rounded-2xl p-6 border border-blue-100 fade-up fade-up-1 flex gap-4 items-start">
                    <span class="material-symbols-outlined text-brand-blue text-2xl mt-0.5">info</span>
                    <div>
                        <p class="font-bold text-blue-900 mb-1">Access Level &mdash; Patient</p>
                        <p class="text-blue-700/80 text-sm">You have standard patient access to your records, appointments, and messages. Contact support if you believe your access level is incorrect.</p>
                    </div>
                </div>

            </div><%-- /security tab --%>

        </div><%-- /content --%>
    </main>
</div>

<%-- Toast notification --%>
<div id="toast"
     class="fixed bottom-8 right-8 bg-slate-900 text-white text-sm font-semibold px-5 py-3.5 rounded-xl shadow-2xl flex items-center gap-3 z-[200] opacity-0 translate-y-4 pointer-events-none">
    <span class="material-symbols-outlined text-mint text-[20px]" style="font-variation-settings:'FILL' 1;">check_circle</span>
    <span id="toastMsg">Changes saved successfully!</span>
</div>

<script>
    /* ── Tab switching ── */
    document.querySelectorAll('.tab-btn').forEach(function(btn) {
        btn.addEventListener('click', function() {
            document.querySelectorAll('.tab-btn').forEach(function(b) { b.classList.remove('active'); });
            document.querySelectorAll('.tab-panel').forEach(function(p) { p.classList.remove('active'); });
            btn.classList.add('active');
            document.getElementById('tab-' + btn.dataset.tab).classList.add('active');
        });
    });

    /* ── isActive toggle ── */
    const toggleCb    = document.getElementById('isActiveCheckbox');
    const hiddenInput = document.getElementById('isActiveValue');
    const activeLabel = document.getElementById('isActiveLabel');

    toggleCb.addEventListener('change', function() {
        hiddenInput.value = toggleCb.checked ? 'true' : 'false';
        activeLabel.textContent = toggleCb.checked ? 'Active' : 'Inactive';
        activeLabel.className = toggleCb.checked
            ? 'ml-3 text-sm font-bold text-slate-700'
            : 'ml-3 text-sm font-bold text-red-500';
    });

    /* ── Blood group display sync ── */
    document.getElementById('bloodGroup').addEventListener('change', function() {
        document.getElementById('bloodGroupDisplay').textContent = this.value;
    });

    /* ── Profile form submit (demo — wire to servlet for real POST) ── */
    document.getElementById('profileForm').addEventListener('submit', function(e) {
        e.preventDefault(); // Remove this line when wired to the real servlet
        showToast('Profile updated successfully!');
    });

    /* ── Password form demo ── */
    function handlePasswordChange(e) {
        e.preventDefault();
        showToast('Password changed successfully!');
    }

    /* ── Toast helper ── */
    function showToast(msg) {
        const toast = document.getElementById('toast');
        document.getElementById('toastMsg').textContent = msg;
        toast.classList.add('show');
        setTimeout(function() { toast.classList.remove('show'); }, 3000);
    }
</script>
</body>
</html>
