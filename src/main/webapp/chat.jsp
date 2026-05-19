<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Upachaar Chat</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
</head>
<body class="min-h-screen bg-slate-100 font-[Inter] text-slate-900">
<div class="min-h-screen flex">
    <aside class="w-[260px] bg-[#0052FF] text-white px-4 py-6 flex flex-col">
        <div class="px-4 mb-10">
            <h1 class="text-2xl font-black tracking-tight text-white uppercase">Upachaar</h1>
            <p class="text-[10px] uppercase tracking-widest text-white/60 font-bold">${sessionScope.userRole} Portal</p>
        </div>

        <nav class="flex-1 flex flex-col gap-1">
            <c:choose>
                <c:when test="${sessionScope.userRole eq 'patient'}">
                    <a class="text-white/70 hover:text-white mx-0 px-4 py-3 transition-all duration-200 hover:bg-white/10 rounded-full flex items-center gap-3"
                       href="${pageContext.request.contextPath}/patient/dashboard.jsp">
                        <span class="material-symbols-outlined">dashboard</span>
                        <span class="text-sm font-medium">Dashboard</span>
                    </a>
                    <a class="text-white/70 hover:text-white mx-0 px-4 py-3 transition-all duration-200 hover:bg-white/10 rounded-full flex items-center gap-3"
                       href="${pageContext.request.contextPath}/patientAppointments">
                        <span class="material-symbols-outlined">history</span>
                        <span class="text-sm font-medium">Appointments</span>
                    </a>
                    <a class="text-white/70 hover:text-white mx-0 px-4 py-3 transition-all duration-200 hover:bg-white/10 rounded-full flex items-center gap-3"
                       href="${pageContext.request.contextPath}/patientProfile">
                        <span class="material-symbols-outlined">settings</span>
                        <span class="text-sm font-medium">Settings</span>
                    </a>
                </c:when>
                <c:otherwise>
                    <a class="flex items-center gap-3 rounded-lg px-4 py-3 text-white/80 hover:bg-white/10"
                       href="${pageContext.request.contextPath}/Receptionist-dashboard">
                        <span class="material-symbols-outlined">dashboard</span>
                        Dashboard
                    </a>
                    <a class="flex items-center gap-3 rounded-lg px-4 py-3 text-white/80 hover:bg-white/10"
                       href="${pageContext.request.contextPath}/receptionists/doctors">
                        <span class="material-symbols-outlined">medical_services</span>
                        Doctors
                    </a>
                    <a class="flex items-center gap-3 rounded-lg px-4 py-3 text-white/80 hover:bg-white/10"
                       href="${pageContext.request.contextPath}/receptionists/patients">
                        <span class="material-symbols-outlined">groups</span>
                        Patients
                    </a>
                    <a class="flex items-center gap-3 rounded-lg px-4 py-3 text-white/80 hover:bg-white/10"
                       href="${pageContext.request.contextPath}/receptionists/appointments">
                        <span class="material-symbols-outlined">calendar_month</span>
                        Appointments
                    </a>
                </c:otherwise>
            </c:choose>
            <a class="bg-white text-[#0052FF] rounded-full mx-0 px-4 py-3 font-semibold transition-all duration-200 flex items-center gap-3 shadow-lg shadow-black/10"
               href="${pageContext.request.contextPath}/chat">
                <span class="material-symbols-outlined" style="font-variation-settings: 'FILL' 1;">forum</span>
                <span class="text-sm font-medium">Chat</span>
            </a>
        </nav>

        <div class="mt-auto border-t border-white/20 pt-5">
            <p class="text-sm font-semibold">${sessionScope.userName}</p>
            <p class="text-xs text-white/60">${sessionScope.userRole}</p>
        </div>
    </aside>

    <main class="flex-1 p-8">
        <div class="mx-auto max-w-6xl">
            <div class="mb-6 flex items-center justify-between">
                <div>
                    <h2 class="text-2xl font-bold">Messages</h2>
                    <p class="text-sm text-slate-500">Patient and receptionist communication</p>
                </div>
                <div class="flex items-center gap-3">
                    <c:if test="${sessionScope.userRole eq 'patient'}">
                        <a href="${pageContext.request.contextPath}/notifications.jsp"
                           class="relative inline-flex size-11 items-center justify-center rounded-full bg-white text-slate-600 shadow-sm border border-slate-200 hover:bg-blue-50 hover:text-[#0052FF] transition-colors"
                           aria-label="Notifications">
                            <span class="material-symbols-outlined">notifications</span>
                            <span class="absolute right-2 top-2 size-2 rounded-full bg-red-500"></span>
                        </a>
                        <div class="flex items-center gap-3 border-l border-slate-200 pl-5">
                            <span class="text-sm font-bold text-slate-900">${sessionScope.userName}</span>
                            <a href="${pageContext.request.contextPath}/patientProfile"
                               class="inline-flex size-10 items-center justify-center rounded-full bg-blue-100 text-[#0052FF] hover:bg-blue-200 transition-colors"
                               aria-label="Profile">
                                <span class="material-symbols-outlined text-3xl">account_circle</span>
                            </a>
                        </div>
                    </c:if>
                    <a href="${pageContext.request.contextPath}/logout"
                       class="inline-flex items-center gap-2 rounded-full bg-slate-900 px-4 py-2 text-sm font-semibold text-white hover:bg-slate-700 transition-colors">
                        <span class="material-symbols-outlined text-[20px]">logout</span>
                        Logout
                    </a>
                </div>
            </div>

            <div class="grid min-h-[680px] grid-cols-[280px_1fr] overflow-hidden rounded-xl border border-slate-200 bg-white shadow-sm">
                <section class="border-r border-slate-200 bg-slate-50">
                    <div class="border-b border-slate-200 p-4">
                        <p class="text-xs font-bold uppercase tracking-wide text-slate-500">
                            <c:choose>
                                <c:when test="${sessionScope.userRole eq 'patient'}">Receptionists</c:when>
                                <c:otherwise>Patients</c:otherwise>
                            </c:choose>
                        </p>
                        <p class="mt-1 text-[11px] text-slate-400">Unread and recent chats</p>
                    </div>
                    <div id="contactsList" class="p-3">
                        <div class="rounded-lg border border-dashed border-slate-300 bg-white p-4 text-sm text-slate-500">
                            Loading contacts...
                        </div>
                    </div>
                </section>

                <section class="flex flex-col">
                    <header class="flex h-16 items-center justify-between border-b border-slate-200 px-6">
                        <div>
                            <p class="text-sm text-slate-500">Conversation with</p>
                            <h3 class="font-bold">${receiverName}</h3>
                        </div>
                    </header>

                    <div id="chatBox" class="flex-1 space-y-3 overflow-y-auto bg-slate-50 p-6"></div>

                    <form id="chatForm" class="flex gap-3 border-t border-slate-200 p-4">
                        <input type="hidden" id="senderId" value="${senderId}">
                        <input type="hidden" id="receiverId" value="${receiverId}">
                        <input id="message"
                               class="flex-1 rounded-lg border border-slate-300 px-4 py-3 text-sm outline-none focus:border-[#0052FF] focus:ring-2 focus:ring-blue-100"
                               placeholder="${receiverId == 0 ? 'Select a contact first' : 'Type your message'}"
                               ${receiverId == 0 ? 'disabled' : ''}
                               autocomplete="off">
                        <button class="inline-flex items-center gap-2 rounded-lg bg-[#0052FF] px-5 py-3 text-sm font-semibold text-white disabled:cursor-not-allowed disabled:bg-slate-300"
                                type="submit"
                                ${receiverId == 0 ? 'disabled' : ''}>
                            <span class="material-symbols-outlined text-[20px]">send</span>
                            Send
                        </button>
                    </form>
                </section>
            </div>
        </div>
    </main>
</div>

<script>
    // Base context path for building absolute URLs from the client
    const BASE = '${pageContext.request.contextPath}';
    const senderId = document.getElementById('senderId').value;
    const receiverId = document.getElementById('receiverId').value;
    const chatBox = document.getElementById('chatBox');
    const form = document.getElementById('chatForm');
    const messageInput = document.getElementById('message');

    function loadMessages() {
        if (!receiverId || receiverId === '0') {
            chatBox.innerHTML = '<div class="text-sm text-slate-500">Select a contact to start chatting.</div>';
            return;
        }

        fetch(BASE + '/getMessages?senderId=' + encodeURIComponent(senderId) + '&receiverId=' + encodeURIComponent(receiverId) + '&_=' + Date.now(), {
            cache: 'no-store'
        })
            .then(response => {
                const contentType = response.headers.get('content-type') || '';
                if (!response.ok || !contentType.includes('text/html')) {
                    console.error('Failed to load messages', response.status, response.url);
                    throw new Error('Unable to load messages');
                }
                return response.text();
            })
            .then(data => {
                chatBox.innerHTML = data || '<div class="text-sm text-slate-500">No messages yet.</div>';
                chatBox.scrollTop = chatBox.scrollHeight;
                loadContactsList();
            })
            .catch(() => {
                chatBox.innerHTML = '<div class="text-sm text-red-500">Unable to load messages.</div>';
            });
    }

    form.addEventListener('submit', function (event) {
        event.preventDefault();
        const message = messageInput.value.trim();
        if (!message || receiverId === '0') {
            return;
        }

        fetch(BASE + '/sendMessage', {
            method: 'POST',
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: 'senderId=' + encodeURIComponent(senderId)
                + '&receiverId=' + encodeURIComponent(receiverId)
                + '&message=' + encodeURIComponent(message)
        }).then(() => {
            messageInput.value = '';
            loadContactsList();
            loadMessages();
        });
    });

    loadMessages();
    setInterval(loadMessages, 1500);

    // Periodically refresh contacts list (to update unread badges and ordering)
    function loadContactsList() {
        fetch(BASE + '/getContacts?receiverId=' + encodeURIComponent(receiverId) + '&_=' + Date.now(), {
            cache: 'no-store'
        })
            .then(response => {
                const contentType = response.headers.get('content-type') || '';
                if (!response.ok || !contentType.includes('text/html')) {
                    console.error('Failed to load contacts', response.status, response.url);
                    throw new Error('Unable to load contacts');
                }
                return response.text();
            })
            .then(html => {
                document.getElementById('contactsList').innerHTML = html;
            })
            .catch(() => {
                document.getElementById('contactsList').innerHTML =
                    '<div class="rounded-lg border border-red-200 bg-red-50 p-4 text-sm text-red-600">Unable to refresh contacts.</div>';
            });
    }

    loadContactsList();
    setInterval(loadContactsList, 1500);

    // Polling already keeps chat and unread badges fresh without requiring WebSocket support.
</script>
</body>
</html>
