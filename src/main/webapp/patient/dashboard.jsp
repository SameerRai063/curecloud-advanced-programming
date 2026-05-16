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
                   href="${pageContext.request.contextPath}/patientAppointments">
                <span class="material-symbols-outlined">history</span>
                <span class="text-sm font-medium">Appointments</span>
            </a>

            <%-- Settings --%>
                <a class="text-white/70 hover:text-white mx-4 px-4 py-3 transition-all duration-200 hover:bg-white/10 rounded-full flex items-center gap-3"
                   href="${pageContext.request.contextPath}/patientProfile">
                <span class="material-symbols-outlined">settings</span>
                <span class="text-sm font-medium">Settings</span>
            </a>
        </nav>

        <%-- Profile Section --%>

    </aside>

    <%-- ===== MAIN CONTENT ===== --%>
    <main class="flex-1 flex flex-col overflow-y-auto">

        <%-- Header --%>


        <div class="flex-1 px-10 pb-10">

            <%-- ===== HEALTH SUMMARY CARDS ===== --%>
            <section class="mt-4 mb-8">
                <div class="flex items-center justify-between mb-6">
                    <h2 class="text-lg font-bold text-slate-800">Quick Actions</h2>
                </div>
                <div class="grid grid-cols-3 gap-6">
                    <div class="bg-brand-blue p-6 rounded-2xl shadow-lg shadow-brand-blue/10 flex flex-col justify-between h-44 text-white group cursor-pointer hover:-translate-y-1 transition-transform">
                        <div class="bg-white/20 size-12 rounded-xl flex items-center justify-center">
                            <span class="material-symbols-outlined">person</span>
                        </div>
                        <div>
                            <p class="text-white/80 text-xs font-medium mb-1">View Details</p>
                            <p class="text-lg font-bold leading-tight">My Profile</p>
                        </div>
                    </div>
                    <div class="bg-mint p-6 rounded-2xl shadow-lg shadow-mint/10 flex flex-col justify-between h-44 text-white group cursor-pointer hover:-translate-y-1 transition-transform">
                        <div class="bg-white/20 size-12 rounded-xl flex items-center justify-center">
                            <span class="material-symbols-outlined">event</span>
                        </div>
                        <div>
                            <p class="text-white/80 text-xs font-medium mb-1">Schedule</p>
                            <p class="text-lg font-bold leading-tight">My Appointments</p>
                        </div>
                    </div>
                    <div class="bg-outstanding-orange p-6 rounded-2xl shadow-lg shadow-orange-500/10 flex flex-col justify-between h-44 text-white group cursor-pointer hover:-translate-y-1 transition-transform">
                        <div class="bg-white/20 size-12 rounded-xl flex items-center justify-center">
                            <span class="material-symbols-outlined">support_agent</span>
                        </div>
                        <%-- Feedback Trigger Card --%>
                        <div class="bg-mint p-6 rounded-2xl shadow-lg shadow-mint/10 flex flex-col justify-between h-44 text-white hover:-translate-y-1 transition-transform cursor-pointer"
                             onclick="document.getElementById('feedbackModal').classList.remove('hidden')">
                            <div class="bg-white/20 size-12 rounded-xl flex items-center justify-center">
                                <span class="material-symbols-outlined" style="font-variation-settings:'FILL' 1">star</span>
                            </div>
                            <div>
                                <p class="text-white/80 text-xs font-medium mb-1">Rate us</p>
                                <p class="text-lg font-bold leading-tight">Provide Feedback</p>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <div class="grid grid-cols-1 gap-8">

                <%-- ===== BOOK NEXT APPOINTMENT ===== --%>
                <section class="col-span-1">
                    <div class="flex items-center justify-between mb-4">
                        <h2 class="text-lg font-bold text-slate-800">Book Next Appointment</h2>
                    </div>
                    <div class="bg-white rounded-2xl p-8 shadow-sm border border-slate-100 flex flex-col items-center justify-center py-16">
                        <div class="size-20 bg-brand-blue/10 rounded-full flex items-center justify-center text-brand-blue mb-6">
                            <span class="material-symbols-outlined text-4xl">calendar_add_on</span>
                        </div>
                        <h3 class="text-2xl font-bold text-slate-900 mb-2">Need to see a doctor?</h3>
                        <p class="text-slate-500 text-center max-w-md mb-8">Schedule your next visit easily. Choose your preferred doctor, date, and time that works best for you.</p>
                        <a href="bookAppointment.jsp"
                           class="bg-brand-blue text-white font-bold py-4 px-10 rounded-xl shadow-lg shadow-brand-blue/20 hover:bg-blue-700 transition-colors flex items-center gap-2">
                            <span class="material-symbols-outlined">add</span>
                            Book Appointment Now
                        </a>
                    </div>
                </section>

            </div>
        </div>
    </main>
</div>
<%-- Feedback Modal — outside all containers --%>
<div id="feedbackModal" class="hidden fixed inset-0 z-[9999] flex items-center justify-center">

    <%-- Backdrop --%>
    <div class="absolute inset-0 bg-black/40 backdrop-blur-sm"
         onclick="document.getElementById('feedbackModal').classList.add('hidden')"></div>

    <%-- Modal Box --%>
    <div class="relative bg-white rounded-2xl shadow-2xl w-full max-w-md mx-4 p-8 z-10">

        <%-- Header --%>
        <div class="flex items-center justify-between mb-6">
            <div>
                <h2 class="text-lg font-bold text-slate-800">Leave Feedback</h2>
                <p class="text-xs text-slate-500 mt-0.5">Your opinion helps us improve.</p>
            </div>
            <button onclick="document.getElementById('feedbackModal').classList.add('hidden')"
                    class="text-slate-400 hover:text-slate-600 transition-colors">
                <span class="material-symbols-outlined">close</span>
            </button>
        </div>

        <%-- Form --%>
        <form method="post" action="<%= request.getContextPath() %>/submitFeedback">

            <%-- Star Rating --%>
            <div class="mb-6">
                <label class="block text-sm font-semibold text-slate-700 mb-3">Rating</label>
                <div class="flex gap-2">
                    <c:forEach begin="1" end="5" var="i">
                        <button type="button"
                                onclick="setRating(${i})"
                                class="star-btn text-3xl text-slate-300 hover:text-yellow-400 transition-colors"
                                data-value="${i}">
                            &#9733;
                        </button>
                    </c:forEach>
                </div>
                <input type="hidden" name="rating" id="ratingInput" value="0" />
                <p id="ratingError" class="text-xs text-red-500 mt-1 hidden">Please select a rating.</p>
            </div>

            <%-- Comment --%>
            <div class="mb-6">
                <label class="block text-sm font-semibold text-slate-700 mb-2">Comment</label>
                <textarea name="comment" rows="4" required
                          placeholder="Tell us about your experience..."
                          class="w-full border border-slate-200 rounded-xl px-4 py-3 text-sm text-slate-700 outline-none focus:ring-2 focus:ring-brand-blue/30 focus:border-brand-blue resize-none transition"></textarea>
            </div>

            <%-- Buttons --%>
            <div class="flex gap-3">
                <button type="button"
                        onclick="document.getElementById('feedbackModal').classList.add('hidden')"
                        class="flex-1 border border-slate-200 text-slate-600 text-sm font-semibold py-2.5 rounded-xl hover:bg-slate-50 transition">
                    Cancel
                </button>
                <button type="submit"
                        onclick="return validateFeedback()"
                        class="flex-1 bg-brand-blue text-white text-sm font-semibold py-2.5 rounded-xl hover:bg-blue-700 transition">
                    Submit
                </button>
            </div>

        </form>
    </div>
</div>

<script>
    function setRating(value) {
        document.getElementById('ratingInput').value = value;
        document.querySelectorAll('.star-btn').forEach(btn => {
            btn.style.color = parseInt(btn.dataset.value) <= value ? '#facc15' : '#cbd5e1';
        });
    }

    function validateFeedback() {
        const rating = document.getElementById('ratingInput').value;
        if (rating === '0') {
            document.getElementById('ratingError').classList.remove('hidden');
            return false;
        }
        return true;
    }
</script>

</body>
</html>
</body>
</html>