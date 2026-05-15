<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html class="light" lang="en">
<head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>Upachaar - Messages</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
    <script id="tailwind-config">
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    colors: {
                        "surface-container-high": "#e2e7ff",
                        "on-background": "#131b2e",
                        "surface": "#faf8ff",
                        "primary-container": "#0052ff",
                        "background": "#faf8ff",
                        "surface-variant": "#dae2fd",
                        "secondary-container": "#e0e3e5",
                        "on-secondary-container": "#626567",
                        "primary": "#003ec7",
                        "outline": "#737688",
                        "error": "#ba1a1a",
                        "outline-variant": "#c3c5d9",
                        "surface-container-lowest": "#ffffff",
                        "surface-container-low": "#f2f3ff",
                        "surface-container": "#eaedff",
                        "on-surface": "#131b2e",
                        "on-surface-variant": "#434656",
                    },
                },
            }
        }
    </script>
    <style>
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
            vertical-align: middle;
        }
        body { font-family: 'Inter', sans-serif; }
        #chatMessages { scroll-behavior: smooth; }
    </style>
</head>
<body class="bg-background text-on-background overflow-hidden">

    <%-- ══════════════════════════════════════════
         SIDEBAR
    ══════════════════════════════════════════ --%>
    <aside class="fixed h-screen w-[260px] left-0 top-0 bg-[#0052FF] text-white shadow-2xl shadow-blue-500/20 flex flex-col py-6 z-50">
        <div class="px-8 mb-8">
            <h1 class="text-2xl font-black tracking-tight text-white uppercase">Upachaar</h1>
            <p class="text-[10px] uppercase tracking-widest text-white/60 font-bold">Patient Portal</p>
        </div>
        <nav class="flex-1 flex flex-col gap-1">
            <a class="text-white/70 hover:text-white mx-4 px-4 py-3 transition-all duration-200 flex items-center gap-3 hover:bg-white/10 rounded-full" href="dashboard.jsp">
                <span class="material-symbols-outlined">dashboard</span>
                <span class="text-sm font-medium">Dashboard</span>
            </a>
            <a class="text-white/70 hover:text-white mx-4 px-4 py-3 transition-all duration-200 hover:bg-white/10 rounded-full flex items-center gap-3"
               href="${pageContext.request.contextPath}/patientAppointments">
                <span class="material-symbols-outlined">history</span>
                <span class="text-sm font-medium">Appointments</span>
            </a>
            <%-- Messages - ACTIVE --%>
            <a class="bg-white text-[#0052FF] rounded-full mx-4 px-4 py-3 font-semibold transition-all duration-200 flex items-center gap-3 shadow-lg shadow-black/10" href="messages.jsp">
                <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1;">chat</span>
                <span class="text-sm font-medium">Messages</span>
            </a>
            <a class="text-white/70 hover:text-white mx-4 px-4 py-3 transition-all duration-200 hover:bg-white/10 rounded-full flex items-center gap-3"
               href="${pageContext.request.contextPath}/patientProfile">
                <span class="material-symbols-outlined">settings</span>
                <span class="text-sm font-medium">Settings</span>
            </a>
        </nav>
        <div class="mt-auto p-8 border-t border-white/10">

        </div>
    </aside>

    <%-- ══════════════════════════════════════════
         TOP BAR
    ══════════════════════════════════════════ --%>
    <header class="fixed top-0 right-0 w-[calc(100%-260px)] h-16 bg-white border-b border-outline-variant shadow-sm flex items-center justify-between px-8 z-40">
        <h1 class="text-xl font-bold text-on-surface">Messages</h1>
        <div class="flex items-center gap-4">
            <button class="w-10 h-10 flex items-center justify-center rounded-full hover:bg-surface-container-low transition-colors">
                <span class="material-symbols-outlined text-on-surface-variant">notifications</span>
            </button>
            <div class="flex items-center gap-3 pl-4 border-l border-outline-variant">
                <p class="text-sm font-bold text-on-surface">John Doe</p>
                <div class="size-9 rounded-full bg-primary-container/10 flex items-center justify-center text-primary-container overflow-hidden">
                    <span class="material-symbols-outlined text-2xl">account_circle</span>
                </div>
            </div>
        </div>
    </header>

    <%-- ══════════════════════════════════════════
         MAIN CHAT AREA
    ══════════════════════════════════════════ --%>
    <main class="ml-[260px] mt-16 h-[calc(100vh-64px)] flex flex-col bg-white">

        <%-- Chat Header --%>
        <div class="px-8 py-4 border-b border-outline-variant flex items-center justify-between bg-white shadow-sm">
            <div class="flex items-center gap-3">
                <div class="relative">
                    <div class="w-11 h-11 rounded-full bg-primary-container/10 flex items-center justify-center">
                        <span class="material-symbols-outlined text-primary-container text-2xl">support_agent</span>
                    </div>
                    <span class="absolute bottom-0 right-0 w-3 h-3 bg-green-500 border-2 border-white rounded-full"></span>
                </div>
                <div>
                    <h2 class="font-bold text-on-surface text-base">Upachaar Receptionist</h2>
                    <span class="text-xs text-green-600 font-semibold uppercase tracking-wider">Online</span>
                </div>
            </div>
            <div class="text-xs text-on-surface-variant bg-surface-container-low px-3 py-1.5 rounded-full font-medium">
                Response time: ~5 minutes
            </div>
        </div>

        <%-- Messages Thread --%>
        <div id="chatMessages" class="flex-1 overflow-y-auto p-8 space-y-6 bg-surface-container-lowest">

            <%-- Date separator --%>
            <div class="flex justify-center">
                <span class="bg-surface-container text-on-surface-variant px-4 py-1 rounded-full text-[10px] font-bold uppercase tracking-widest">Today</span>
            </div>

            <%-- Incoming: Receptionist --%>
            <div class="flex items-end gap-3 max-w-[75%]">
                <div class="w-8 h-8 rounded-full bg-primary-container/10 flex items-center justify-center shrink-0">
                    <span class="material-symbols-outlined text-primary-container text-lg">support_agent</span>
                </div>
                <div class="flex flex-col">
                    <div class="bg-white border border-outline-variant px-4 py-3 rounded-xl rounded-bl-none shadow-sm">
                        <p class="text-sm text-on-surface">Hello, John! &#128075; Welcome to Upachaar. I'm here to help you with any questions about your appointments, prescriptions, or anything else. How can I assist you today?</p>
                    </div>
                    <span class="text-[10px] text-on-surface-variant mt-1 ml-1">10:00 AM</span>
                </div>
            </div>

            <%-- Outgoing: Patient --%>
            <div class="flex items-end gap-3 justify-end ml-auto max-w-[75%]">
                <div class="flex flex-col items-end">
                    <div class="bg-primary-container text-white px-4 py-3 rounded-xl rounded-br-none shadow-lg">
                        <p class="text-sm">Hi! I wanted to ask about my upcoming appointment with Dr. Sarah Jenkins. Can I reschedule it?</p>
                    </div>
                    <div class="flex items-center gap-1 mt-1 mr-1">
                        <span class="text-[10px] text-on-surface-variant">10:03 AM</span>
                        <span class="material-symbols-outlined text-primary-container text-[14px]" style="font-variation-settings: 'FILL' 1;">done_all</span>
                    </div>
                </div>
            </div>

            <%-- Incoming: Receptionist --%>
            <div class="flex items-end gap-3 max-w-[75%]">
                <div class="w-8 h-8 rounded-full bg-primary-container/10 flex items-center justify-center shrink-0">
                    <span class="material-symbols-outlined text-primary-container text-lg">support_agent</span>
                </div>
                <div class="flex flex-col">
                    <div class="bg-white border border-outline-variant px-4 py-3 rounded-xl rounded-bl-none shadow-sm">
                        <p class="text-sm text-on-surface">Of course! I can see your appointment with Dr. Jenkins is scheduled for <strong>October 26 at 2:30 PM</strong>. What date works better for you?</p>
                    </div>
                    <span class="text-[10px] text-on-surface-variant mt-1 ml-1">10:05 AM</span>
                </div>
            </div>

        </div>

        <%-- Message Input --%>
        <div class="px-8 py-4 border-t border-outline-variant bg-white">
            <div class="flex items-center gap-3 bg-surface-container-low rounded-xl px-4 py-2 border border-outline-variant focus-within:border-primary-container focus-within:ring-1 focus-within:ring-primary-container transition-all">
                <button class="text-on-surface-variant hover:text-primary-container transition-colors">
                    <span class="material-symbols-outlined">attach_file</span>
                </button>
                <input id="messageInput"
                       class="flex-1 bg-transparent border-none focus:ring-0 outline-none text-sm text-on-surface placeholder:text-on-surface-variant"
                       placeholder="Type your message..."
                       type="text"
                       onkeydown="if(event.key==='Enter') sendMessage()"/>
                <button class="text-on-surface-variant hover:text-primary-container transition-colors">
                    <span class="material-symbols-outlined">sentiment_satisfied</span>
                </button>
                <button onclick="sendMessage()"
                        class="bg-primary-container text-white px-5 py-2 rounded-lg text-sm font-semibold flex items-center gap-2 hover:bg-primary transition-all active:scale-95">
                    Send
                    <span class="material-symbols-outlined text-[16px]">send</span>
                </button>
            </div>
            <p class="text-[10px] text-on-surface-variant mt-2 text-center">Your messages are only visible to the Upachaar reception team.</p>
        </div>
    </main>

    <script>
        function sendMessage() {
            const input = document.getElementById('messageInput');
            const text = input.value.trim();
            if (!text) return;

            const thread = document.getElementById('chatMessages');
            const now = new Date();
            const time = now.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });

            // Outgoing bubble
            const msg = document.createElement('div');
            msg.className = 'flex items-end gap-3 justify-end ml-auto max-w-[75%]';
            msg.innerHTML =
                '<div class="flex flex-col items-end">' +
                    '<div class="bg-primary-container text-white px-4 py-3 rounded-xl rounded-br-none shadow-lg">' +
                        '<p class="text-sm">' + text.replace(/</g, '&lt;').replace(/>/g, '&gt;') + '</p>' +
                    '</div>' +
                    '<div class="flex items-center gap-1 mt-1 mr-1">' +
                        '<span class="text-[10px] text-on-surface-variant">' + time + '</span>' +
                        '<span class="material-symbols-outlined text-primary-container text-[14px]" style="font-variation-settings:\'FILL\' 1;">done_all</span>' +
                    '</div>' +
                '</div>';
            thread.appendChild(msg);
            input.value = '';
            thread.scrollTop = thread.scrollHeight;

            // Simulate receptionist reply after 1.5s
            setTimeout(function() {
                const replies = [
                    "Thanks for letting us know! I'll check the available slots and get back to you shortly.",
                    "Got it! Is there a preferred time of day that works best for you?",
                    "Sure thing! Let me look into that for you right away.",
                    "I've noted your request. Our team will follow up within a few minutes.",
                ];
                const replyText = replies[Math.floor(Math.random() * replies.length)];
                const replyTime = new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
                const reply = document.createElement('div');
                reply.className = 'flex items-end gap-3 max-w-[75%]';
                reply.innerHTML =
                    '<div class="w-8 h-8 rounded-full bg-primary-container/10 flex items-center justify-center shrink-0">' +
                        '<span class="material-symbols-outlined text-primary-container text-lg">support_agent</span>' +
                    '</div>' +
                    '<div class="flex flex-col">' +
                        '<div class="bg-white border border-outline-variant px-4 py-3 rounded-xl rounded-bl-none shadow-sm">' +
                            '<p class="text-sm text-on-surface">' + replyText + '</p>' +
                        '</div>' +
                        '<span class="text-[10px] text-on-surface-variant mt-1 ml-1">' + replyTime + '</span>' +
                    '</div>';
                thread.appendChild(reply);
                thread.scrollTop = thread.scrollHeight;
            }, 1500);
        }
    </script>
</body>
</html>
