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
        .fade-up   { animation: fadeUp 0.35s ease both; }
        .fade-up-1 { animation-delay: 0.05s; }
        .fade-up-2 { animation-delay: 0.10s; }
        .fade-up-3 { animation-delay: 0.15s; }
        /* save toast */
        #toast { transition: opacity 0.3s, transform 0.3s; }
        #toast.show { opacity: 1 !important; transform: translateY(0) !important; }

        /* password strength bar */
        .strength-bar { transition: width 0.3s ease, background-color 0.3s ease; }

        /* section divider */
        .section-divider {
            display: flex;
            align-items: center;
            gap: 12px;
            margin: 8px 0;
        }
        .section-divider::before,
        .section-divider::after {
            content: '';
            flex: 1;
            height: 1px;
            background: #e2e8f0;
        }
    </style>
</head>
<body class="text-slate-900 antialiased">

<div class="flex h-screen w-full">

    <%-- SIDEBAR --%>
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
            <a class="text-white/70 hover:text-white mx-4 px-4 py-3 transition-all duration-200 hover:bg-white/10 rounded-full flex items-center gap-3"
               href="${pageContext.request.contextPath}/patientAppointments">
                <span class="material-symbols-outlined">history</span>
                <span class="text-sm font-medium">Appointments</span>
            </a>
            <a class="text-white/70 hover:text-white mx-4 px-4 py-3 transition-all duration-200 hover:bg-white/10 rounded-full flex items-center gap-3" href="messages.jsp">
                <span class="material-symbols-outlined">chat</span>
                <span class="text-sm font-medium">Messages</span>
            </a>
            <a class="text-white/70 hover:text-white mx-4 px-4 py-3 transition-all duration-200 hover:bg-white/10 rounded-full flex items-center gap-3"
               href="${pageContext.request.contextPath}/patientProfile">
                <span class="material-symbols-outlined" style="font-variation-settings:'FILL' 1;">settings</span>
                <span class="text-sm font-medium">Settings</span>
            </a>
        </nav>
        <%-- Profile --%>
        <div class="mt-auto p-8 border-t border-white/10">
        </div>
    </aside>

    <%-- MAIN --%>
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
                        <p class="text-sm font-bold text-slate-900 leading-none">${sessionScope.loggedInUser.name}</p>

                    </div>
                    <div class="size-10 rounded-full bg-brand-blue/10 flex items-center justify-center text-brand-blue overflow-hidden">
                        <span class="material-symbols-outlined text-3xl">account_circle</span>
                    </div>
                </div>
            </div>
        </header>

        <div class="flex-1 px-10 py-8 max-w-5xl w-full mx-auto">

            <%-- Profile hero card --%>


            <%-- MERGED FORM --%>
                <div class="bg-white rounded-2xl shadow-sm border border-slate-100 p-8 fade-up fade-up-1">

                    <%-- Flash Messages --%>
                    <c:if test="${not empty sessionScope.success}">
                        <div class="mb-4 bg-green-50 border border-green-200 text-green-700 text-sm rounded-xl px-4 py-3 flex items-center gap-2">
                            <span class="material-symbols-outlined text-[18px]">check_circle</span>
                                ${sessionScope.success}
                        </div>
                    </c:if>
                    <c:if test="${not empty sessionScope.error}">
                        <div class="mb-4 bg-red-50 border border-red-200 text-red-700 text-sm rounded-xl px-4 py-3 flex items-center gap-2">
                            <span class="material-symbols-outlined text-[18px]">error</span>
                                ${sessionScope.error}
                        </div>
                    </c:if>
                    <% session.removeAttribute("success"); session.removeAttribute("error"); %>

                    <form action="${pageContext.request.contextPath}/updatePatient" method="POST" id="settingsForm">

                        <%-- Single hidden input --%>
                        <input type="hidden" name="targetUserId" value="${patient.user.id}">

                        <%-- Section: Profile Information --%>
                        <h3 class="text-base font-bold text-slate-800 mb-6 flex items-center gap-2">
                            <span class="material-symbols-outlined text-brand-blue">edit_note</span>
                            Profile Information
                        </h3>

                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">

                            <%-- Full Name --%>
                            <div class="space-y-1.5">
                                <label class="text-xs font-bold text-slate-500 uppercase tracking-wider" for="name">Full Name</label>
                                <div class="relative">
                                    <span class="absolute left-3.5 top-1/2 -translate-y-1/2 material-symbols-outlined text-slate-400 text-[18px]">person</span>
                                    <input id="name" name="name" type="text" value="${patient.user.name}" required
                                           class="w-full pl-10 pr-4 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm font-medium text-slate-900 transition-all">
                                </div>
                            </div>

                            <%-- Phone --%>
                            <div class="space-y-1.5">
                                <label class="text-xs font-bold text-slate-500 uppercase tracking-wider" for="phone">Phone Number</label>
                                <div class="relative">
                                    <span class="absolute left-3.5 top-1/2 -translate-y-1/2 material-symbols-outlined text-slate-400 text-[18px]">call</span>
                                    <input id="phone" name="phone" type="tel" value="${patient.user.phone}" required
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
                                        <option value="Male"             ${patient.user.gender eq 'Male'             ? 'selected' : ''}>Male</option>
                                        <option value="Female"           ${patient.user.gender eq 'Female'           ? 'selected' : ''}>Female</option>
                                        <option value="Other"            ${patient.user.gender eq 'Other'            ? 'selected' : ''}>Other</option>
                                        <option value="Prefer not to say"${patient.user.gender eq 'Prefer not to say'? 'selected' : ''}>Prefer not to say</option>
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
                                        <option value="A+"  ${patient.bloodGroup eq 'A+'  ? 'selected' : ''}>A+</option>
                                        <option value="A-"  ${patient.bloodGroup eq 'A-'  ? 'selected' : ''}>A-</option>
                                        <option value="B+"  ${patient.bloodGroup eq 'B+'  ? 'selected' : ''}>B+</option>
                                        <option value="B-"  ${patient.bloodGroup eq 'B-'  ? 'selected' : ''}>B-</option>
                                        <option value="AB+" ${patient.bloodGroup eq 'AB+' ? 'selected' : ''}>AB+</option>
                                        <option value="AB-" ${patient.bloodGroup eq 'AB-' ? 'selected' : ''}>AB-</option>
                                        <option value="O+"  ${patient.bloodGroup eq 'O+'  ? 'selected' : ''}>O+</option>
                                        <option value="O-"  ${patient.bloodGroup eq 'O-'  ? 'selected' : ''}>O-</option>
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
                                              class="w-full pl-10 pr-4 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm font-medium text-slate-900 resize-none transition-all">${patient.user.address}</textarea>
                                </div>
                            </div>

                        </div>

                        <%-- Divider --%>
                        <div class="section-divider my-8">
            <span class="text-xs font-bold text-slate-400 uppercase tracking-widest whitespace-nowrap px-2">
                <span class="material-symbols-outlined text-[14px] align-middle mr-1">lock</span>
                Change Password
            </span>
                        </div>

                        <%-- Section: Security --%>
                        <p class="text-xs text-slate-400 mb-5">Leave password fields blank if you don't want to change it.</p>

                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">

                            <%-- Current Password --%>
                            <div class="space-y-1.5 md:col-span-2">
                                <label class="text-xs font-bold text-slate-500 uppercase tracking-wider" for="currentPassword">Current Password</label>
                                <div class="relative">
                                    <span class="absolute left-3.5 top-1/2 -translate-y-1/2 material-symbols-outlined text-slate-400 text-[18px]">lock</span>
                                    <input id="currentPassword" name="currentPassword" type="password"
                                           placeholder="Enter your current password"
                                           class="w-full pl-10 pr-11 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm font-medium text-slate-900 transition-all">
                                    <button type="button" onclick="toggleVisibility('currentPassword', this)"
                                            class="absolute right-3.5 top-1/2 -translate-y-1/2 text-slate-400 hover:text-slate-600 transition-colors">
                                        <span class="material-symbols-outlined text-[18px]">visibility</span>
                                    </button>
                                </div>
                            </div>

                            <%-- New Password --%>
                            <div class="space-y-1.5">
                                <label class="text-xs font-bold text-slate-500 uppercase tracking-wider" for="newPassword">New Password</label>
                                <div class="relative">
                                    <span class="absolute left-3.5 top-1/2 -translate-y-1/2 material-symbols-outlined text-slate-400 text-[18px]">lock_open</span>
                                    <input id="newPassword" name="newPassword" type="password"
                                           placeholder="Enter new password"
                                           oninput="checkStrength(this.value)"
                                           class="w-full pl-10 pr-11 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm font-medium text-slate-900 transition-all">
                                    <button type="button" onclick="toggleVisibility('newPassword', this)"
                                            class="absolute right-3.5 top-1/2 -translate-y-1/2 text-slate-400 hover:text-slate-600 transition-colors">
                                        <span class="material-symbols-outlined text-[18px]">visibility</span>
                                    </button>
                                </div>
                                <div class="h-1.5 bg-slate-100 rounded-full overflow-hidden mt-2">
                                    <div id="strengthBar" class="strength-bar h-full w-0 rounded-full bg-slate-300"></div>
                                </div>
                                <p id="strengthLabel" class="text-xs text-slate-400 mt-1"></p>
                            </div>

                            <%-- Confirm Password --%>
                            <div class="space-y-1.5">
                                <label class="text-xs font-bold text-slate-500 uppercase tracking-wider" for="confirmPassword">Confirm New Password</label>
                                <div class="relative">
                                    <span class="absolute left-3.5 top-1/2 -translate-y-1/2 material-symbols-outlined text-slate-400 text-[18px]">verified_user</span>
                                    <input id="confirmPassword" name="confirmPassword" type="password"
                                           placeholder="Re-enter new password"
                                           oninput="checkMatch()"
                                           class="w-full pl-10 pr-11 py-3 bg-slate-50 border border-slate-200 rounded-xl text-sm font-medium text-slate-900 transition-all">
                                    <button type="button" onclick="toggleVisibility('confirmPassword', this)"
                                            class="absolute right-3.5 top-1/2 -translate-y-1/2 text-slate-400 hover:text-slate-600 transition-colors">
                                        <span class="material-symbols-outlined text-[18px]">visibility</span>
                                    </button>
                                </div>
                                <p id="matchLabel" class="text-xs mt-1"></p>
                            </div>

                        </div>

                        <%-- Access level info --%>
                        <div class="mt-6 bg-blue-50 rounded-xl p-4 border border-blue-100 flex gap-3 items-start">
                            <span class="material-symbols-outlined text-brand-blue text-xl mt-0.5">info</span>
                            <div>
                                <p class="font-bold text-blue-900 text-sm">Access Level &mdash; Patient</p>
                                <p class="text-blue-700/80 text-xs mt-0.5">You have standard patient access. Contact support if you believe your access level is incorrect.</p>
                            </div>
                        </div>

                        <%-- Submit --%>
                        <div class="flex justify-end pt-6">
                            <button type="submit"
                                    class="bg-brand-blue text-white font-bold px-8 py-3.5 rounded-xl shadow-lg shadow-brand-blue/25 hover:opacity-90 active:scale-95 transition-all flex items-center gap-2">
                                <span class="material-symbols-outlined text-[20px]">save</span>
                                Save All Changes
                            </button>
                        </div>

                    </form>
                </div>

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
    /* Blood group display sync */
    document.getElementById('bloodGroup').addEventListener('change', function() {
        document.getElementById('bloodGroupDisplay').textContent = this.value;
    });

    /* Toggle password visibility */
    function toggleVisibility(fieldId, btn) {
        const input = document.getElementById(fieldId);
        const icon  = btn.querySelector('.material-symbols-outlined');
        if (input.type === 'password') {
            input.type = 'text';
            icon.textContent = 'visibility_off';
        } else {
            input.type = 'password';
            icon.textContent = 'visibility';
        }
    }

    /* Password strength */
    function checkStrength(val) {
        const bar   = document.getElementById('strengthBar');
        const label = document.getElementById('strengthLabel');
        if (!val) { bar.style.width = '0'; label.textContent = ''; return; }
        let score = 0;
        if (val.length >= 8)              score++;
        if (/[A-Z]/.test(val))            score++;
        if (/[0-9]/.test(val))            score++;
        if (/[^A-Za-z0-9]/.test(val))    score++;
        const levels = [
            { w: '25%',  color: '#ef4444', text: 'Weak' },
            { w: '50%',  color: '#f97316', text: 'Fair' },
            { w: '75%',  color: '#eab308', text: 'Good' },
            { w: '100%', color: '#22c55e', text: 'Strong' },
        ];
        const lv = levels[score - 1] || levels[0];
        bar.style.width           = lv.w;
        bar.style.backgroundColor = lv.color;
        label.textContent         = lv.text;
        label.style.color         = lv.color;
    }

    /* Password match */
    function checkMatch() {
        const np = document.getElementById('newPassword').value;
        const cp = document.getElementById('confirmPassword').value;
        const ml = document.getElementById('matchLabel');
        if (!cp) { ml.textContent = ''; return; }
        if (np === cp) {
            ml.textContent = 'Passwords match';
            ml.style.color = '#22c55e';
        } else {
            ml.textContent = 'Passwords do not match';
            ml.style.color = '#ef4444';
        }
    }

    /* Form submit */
    document.getElementById('settingsForm').addEventListener('submit', function(e) {
        const np = document.getElementById('newPassword').value;
        const cp = document.getElementById('confirmPassword').value;
        if (np && np !== cp) {
            e.preventDefault();
            showToast('Passwords do not match!', true);
            return;
        }
        // e.preventDefault(); // Remove when wired to real servlet
        showToast('Changes saved successfully!');
    });

    /* Toast helper */
    function showToast(msg, isError) {
        const toast = document.getElementById('toast');
        const icon  = toast.querySelector('.material-symbols-outlined');
        document.getElementById('toastMsg').textContent = msg;
        icon.textContent = isError ? 'error' : 'check_circle';
        icon.style.color = isError ? '#ef4444' : '#70C1B3';
        toast.classList.add('show');
        setTimeout(function() { toast.classList.remove('show'); }, 3000);
    }
</script>
</body>
</html>
