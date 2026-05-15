<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html class="light" lang="en">
<head>
    <meta charset="utf-8">
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <title>Appointment History - Upachaar</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
    <style>
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
        }
        body { font-family: 'Inter', sans-serif; }
        #bookingModal { transition: opacity 0.2s ease; }
        #bookingModal.hidden { display: none; }
    </style>
    <script id="tailwind-config">
        tailwind.config = {
            darkMode: "class",
            theme: {
                extend: {
                    "colors": {
                        "on-secondary-container": "#626567",
                        "surface": "#faf8ff",
                        "background": "#faf8ff",
                        "on-background": "#131b2e",
                        "surface-variant": "#dae2fd",
                        "outline-variant": "#c3c5d9",
                        "surface-container": "#eaedff",
                        "primary-container": "#0052ff",
                        "on-surface": "#131b2e",
                        "primary": "#003ec7"
                    },
                    "fontFamily": {
                        "body-md": ["Inter"],
                        "headline-sm": ["Inter"],
                        "button": ["Inter"]
                    }
                }
            }
        }
    </script>
</head>
<body class="bg-surface text-on-surface antialiased font-body-md overflow-x-hidden">

    <%-- ══════════════════════════════════════════
         REVIEW MODAL
    ══════════════════════════════════════════ --%>
    <div id="reviewModal" class="hidden fixed inset-0 z-[100] flex items-center justify-center bg-black/50 backdrop-blur-sm">
        <div class="bg-white dark:bg-slate-900 rounded-xl p-6 w-full max-w-md shadow-2xl border border-slate-200 dark:border-slate-800">
            <div class="flex justify-between items-center mb-4">
                <h3 class="text-xl font-bold text-slate-900 dark:text-white">Write a Review</h3>
                <button onclick="closeReviewModal()" class="text-slate-400 hover:text-slate-600 transition-colors">
                    <span class="material-symbols-outlined">close</span>
                </button>
            </div>
            <p class="text-sm text-slate-500 mb-4">How was your experience during the consultation with
                <span id="reviewDoctorName" class="font-bold text-slate-700">the doctor</span>?
            </p>
            <div id="starRating" class="flex gap-2 mb-6 justify-center">
                <span class="star material-symbols-outlined text-slate-300 cursor-pointer text-4xl hover:scale-110 transition-transform" data-val="1">star</span>
                <span class="star material-symbols-outlined text-slate-300 cursor-pointer text-4xl hover:scale-110 transition-transform" data-val="2">star</span>
                <span class="star material-symbols-outlined text-slate-300 cursor-pointer text-4xl hover:scale-110 transition-transform" data-val="3">star</span>
                <span class="star material-symbols-outlined text-slate-300 cursor-pointer text-4xl hover:scale-110 transition-transform" data-val="4">star</span>
                <span class="star material-symbols-outlined text-slate-300 cursor-pointer text-4xl hover:scale-110 transition-transform" data-val="5">star</span>
            </div>
            <textarea id="reviewText"
                class="w-full border border-slate-200 rounded-lg p-3 h-32 focus:outline-none focus:border-primary-container focus:ring-1 focus:ring-primary-container mb-6 text-sm resize-none bg-slate-50"
                placeholder="Share your feedback about the doctor and staff here..."></textarea>
            <div class="flex justify-end gap-3">
                <button onclick="closeReviewModal()" class="px-5 py-2.5 text-sm font-semibold border border-slate-300 rounded-lg text-slate-600 hover:bg-slate-50 transition-colors">Cancel</button>
                <button onclick="submitReview()" class="px-5 py-2.5 text-sm font-semibold bg-primary-container text-white rounded-lg hover:bg-primary shadow-lg shadow-primary/20 transition-all active:scale-95">Submit Review</button>
            </div>
        </div>
    </div>

    <%-- ══════════════════════════════════════════
         BOOKING MODAL
    ══════════════════════════════════════════ --%>
    <div id="bookingModal" class="hidden fixed inset-0 z-[90] flex items-start justify-center bg-black/50 backdrop-blur-sm overflow-y-auto py-8 px-4">
        <div class="bg-surface rounded-2xl shadow-2xl w-full max-w-5xl relative">

            <%-- Modal header --%>
            <div class="flex justify-between items-center px-8 py-5 border-b border-outline-variant/40 bg-white rounded-t-2xl">
                <h2 class="text-xl font-bold text-on-background">Book an Appointment</h2>
                <button onclick="closeBookingModal()" class="text-slate-400 hover:text-slate-600 transition-colors p-1">
                    <span class="material-symbols-outlined">close</span>
                </button>
            </div>

            <%-- Modal body — the full booking form --%>
            <form id="appointmentForm" action="appointmentCreate.jsp" method="POST">
                <input type="hidden" name="patientId" value="1">
                <input type="hidden" name="doctorId" id="hiddenDoctorId" value="1">
                <input type="hidden" name="appointmentDate" id="hiddenAppointmentDate" value="">
                <input type="hidden" name="appointmentTime" id="hiddenAppointmentTime" value="">
                <input type="hidden" name="status" value="Scheduled">

                <div class="px-8 py-6">
                    <div class="grid grid-cols-12 gap-6">

                        <%-- Left column --%>
                        <div class="col-span-12 lg:col-span-8 space-y-6">

                            <%-- Department --%>
                            <section class="bg-white rounded-xl p-6 shadow-[0px_4px_12px_rgba(0,0,0,0.05)] border border-outline-variant/30">
                                <div class="flex items-center gap-3 mb-6">
                                    <span class="material-symbols-outlined text-primary-container">clinical_notes</span>
                                    <h2 class="text-xl font-bold text-on-background">Select Department</h2>
                                </div>
                                <select id="departmentSelect" name="department"
                                    class="w-full px-4 py-4 bg-surface-variant/20 border border-outline-variant rounded-lg appearance-none focus:ring-2 focus:ring-primary-container/20 focus:border-primary-container transition-all text-on-surface font-medium outline-none">
                                    <option value="Cardiology Specialist Center">Cardiology Specialist Center</option>
                                    <option value="Neurology &amp; Wellness">Neurology &amp; Wellness</option>
                                    <option value="Pediatrics &amp; Child Care">Pediatrics &amp; Child Care</option>
                                    <option value="Orthopedic Surgery">Orthopedic Surgery</option>
                                    <option value="General Internal Medicine">General Internal Medicine</option>
                                </select>
                            </section>

                            <%-- Specialist --%>
                            <section class="bg-white rounded-xl p-6 shadow-[0px_4px_12px_rgba(0,0,0,0.05)] border border-outline-variant/30">
                                <div class="flex items-center gap-3 mb-6">
                                    <span class="material-symbols-outlined text-primary-container">person_search</span>
                                    <h2 class="text-xl font-bold text-on-background">Choose Your Specialist</h2>
                                </div>
                                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                    <div class="doctor-card relative border-2 border-primary-container bg-primary/5 rounded-xl p-4 flex gap-4 transition-all hover:shadow-md cursor-pointer"
                                        data-id="1" data-name="Dr. Arjun Mehta" data-department="Cardiology Specialist Center" data-fee="120"
                                        onclick="selectDoctor(this)">
                                        <div>
                                            <h3 class="font-bold text-sm mb-0.5">Dr. Arjun Mehta</h3>
                                            <p class="text-xs text-primary-container uppercase mb-2">Senior Cardiologist</p>
                                        </div>
                                    </div>
                                    <div class="doctor-card border border-outline-variant hover:border-primary-container/40 rounded-xl p-4 flex gap-4 transition-all hover:bg-slate-50 cursor-pointer"
                                        data-id="2" data-name="Dr. Sarah Jenkins" data-department="Cardiology Specialist Center" data-fee="150"
                                        onclick="selectDoctor(this)">
                                        <div>
                                            <h3 class="font-bold text-sm mb-0.5">Dr. Sarah Jenkins</h3>
                                            <p class="text-xs text-on-secondary-container uppercase mb-2">Cardiac Surgeon</p>
                                        </div>
                                    </div>
                                </div>
                            </section>

                            <%-- Reason for Visit --%>
                            <section class="bg-white rounded-xl p-6 shadow-[0px_4px_12px_rgba(0,0,0,0.05)] border border-outline-variant/30">
                                <div class="flex items-center gap-3 mb-6">
                                    <span class="material-symbols-outlined text-primary-container">edit_note</span>
                                    <h2 class="text-xl font-bold text-on-background">Reason for Visit</h2>
                                </div>
                                <textarea name="reason" rows="3" required
                                    class="w-full p-4 bg-surface-variant/20 border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary-container/20 focus:border-primary-container transition-all text-on-surface font-medium outline-none"
                                    placeholder="Briefly describe your symptoms or reason for visit..."></textarea>
                            </section>

                        </div>

                        <%-- Right column --%>
                        <div class="col-span-12 lg:col-span-4 space-y-6">

                            <%-- Calendar + Slots --%>
                            <section class="bg-white rounded-xl p-6 shadow-[0px_4px_12px_rgba(0,0,0,0.05)] border border-outline-variant/30">
                                <div class="flex items-center gap-3 mb-6">
                                    <span class="material-symbols-outlined text-primary-container">calendar_today</span>
                                    <h2 class="text-xl font-bold text-on-background">Select Schedule</h2>
                                </div>

                                <div class="mb-8">
                                    <div class="flex justify-between items-center mb-4">
                                        <h4 id="calMonthLabel" class="font-bold text-slate-900"></h4>
                                        <div class="flex gap-2">
                                            <button type="button" id="calPrev" class="p-1.5 hover:bg-slate-100 rounded-full transition-colors">
                                                <span class="material-symbols-outlined text-sm">chevron_left</span>
                                            </button>
                                            <button type="button" id="calNext" class="p-1.5 hover:bg-slate-100 rounded-full transition-colors">
                                                <span class="material-symbols-outlined text-sm">chevron_right</span>
                                            </button>
                                        </div>
                                    </div>
                                    <div class="grid grid-cols-7 gap-1 text-center" id="calGrid">
                                        <div class="text-[10px] font-bold text-slate-400 uppercase py-2">Su</div>
                                        <div class="text-[10px] font-bold text-slate-400 uppercase py-2">Mo</div>
                                        <div class="text-[10px] font-bold text-slate-400 uppercase py-2">Tu</div>
                                        <div class="text-[10px] font-bold text-slate-400 uppercase py-2">We</div>
                                        <div class="text-[10px] font-bold text-slate-400 uppercase py-2">Th</div>
                                        <div class="text-[10px] font-bold text-slate-400 uppercase py-2">Fr</div>
                                        <div class="text-[10px] font-bold text-slate-400 uppercase py-2">Sa</div>
                                    </div>
                                </div>

                                <div>
                                    <h4 class="font-bold text-slate-900 mb-4">Available Slots</h4>
                                    <div class="grid grid-cols-3 gap-2">
                                        <button type="button" class="time-slot py-2 px-2 bg-surface-variant/30 border border-outline-variant rounded-lg text-[11px] font-bold hover:border-primary-container transition-all" data-time="09:00 AM" onclick="selectTime(this)">09:00 AM</button>
                                        <button type="button" class="time-slot py-2 px-2 bg-surface-variant/30 border border-outline-variant rounded-lg text-[11px] font-bold hover:border-primary-container transition-all" data-time="09:30 AM" onclick="selectTime(this)">09:30 AM</button>
                                        <button type="button" class="time-slot py-2 px-2 bg-surface-variant/30 border border-outline-variant rounded-lg text-[11px] font-bold hover:border-primary-container transition-all" data-time="10:00 AM" onclick="selectTime(this)">10:00 AM</button>
                                        <button type="button" class="time-slot py-2 px-2 bg-surface-variant/30 border border-outline-variant rounded-lg text-[11px] font-bold hover:border-primary-container transition-all" data-time="10:30 AM" onclick="selectTime(this)">10:30 AM</button>
                                        <button type="button" class="time-slot py-2 px-2 bg-surface-variant/30 border border-outline-variant rounded-lg text-[11px] font-bold hover:border-primary-container transition-all" data-time="11:00 AM" onclick="selectTime(this)">11:00 AM</button>
                                        <button type="button" class="time-slot py-2 px-2 bg-surface-variant/30 border border-outline-variant rounded-lg text-[11px] font-bold hover:border-primary-container transition-all" data-time="11:30 AM" onclick="selectTime(this)">11:30 AM</button>
                                        <button type="button" class="time-slot py-2 px-2 bg-surface-variant/30 border border-outline-variant rounded-lg text-[11px] font-bold hover:border-primary-container transition-all" data-time="01:00 PM" onclick="selectTime(this)">01:00 PM</button>
                                        <button type="button" class="time-slot py-2 px-2 bg-surface-variant/30 border border-outline-variant rounded-lg text-[11px] font-bold hover:border-primary-container transition-all" data-time="01:30 PM" onclick="selectTime(this)">01:30 PM</button>
                                        <button type="button" class="time-slot py-2 px-2 bg-surface-variant/30 border border-outline-variant rounded-lg text-[11px] font-bold hover:border-primary-container transition-all" data-time="02:00 PM" onclick="selectTime(this)">02:00 PM</button>
                                        <button type="button" class="time-slot py-2 px-2 bg-surface-variant/30 border border-outline-variant rounded-lg text-[11px] font-bold hover:border-primary-container transition-all" data-time="02:30 PM" onclick="selectTime(this)">02:30 PM</button>
                                        <button type="button" class="time-slot py-2 px-2 bg-surface-variant/30 border border-outline-variant rounded-lg text-[11px] font-bold hover:border-primary-container transition-all" data-time="03:00 PM" onclick="selectTime(this)">03:00 PM</button>
                                        <button type="button" class="time-slot py-2 px-2 bg-surface-variant/30 border border-outline-variant rounded-lg text-[11px] font-bold hover:border-primary-container transition-all" data-time="03:30 PM" onclick="selectTime(this)">03:30 PM</button>
                                    </div>
                                </div>
                            </section>

                            <%-- Booking Summary --%>
                            <section class="bg-primary-container rounded-xl p-6 text-white shadow-xl shadow-blue-500/20">
                                <h4 class="font-bold mb-4 flex items-center gap-2">
                                    <span class="material-symbols-outlined text-sm">info</span> Booking Summary
                                </h4>
                                <div class="space-y-3">
                                    <div class="flex justify-between text-sm opacity-80">
                                        <span>Doctor</span>
                                        <span id="summaryDoctor" class="font-bold opacity-100">Dr. Arjun Mehta</span>
                                    </div>
                                    <div class="flex justify-between text-sm opacity-80">
                                        <span>Date</span>
                                        <span id="summaryDate" class="font-bold opacity-100">&mdash;</span>
                                    </div>
                                    <div class="flex justify-between text-sm opacity-80">
                                        <span>Time</span>
                                        <span id="summaryTime" class="font-bold opacity-100">&mdash;</span>
                                    </div>
                                    <div class="pt-3 border-t border-white/20 flex justify-between font-bold">
                                        <span>Consultation Fee</span>
                                        <span id="summaryFee">$120.00</span>
                                    </div>
                                </div>
                            </section>

                        </div>
                    </div>

                    <%-- Form actions --%>
                    <div class="mt-6 flex items-center justify-between border-t border-slate-200 pt-6">
                        <button type="button" onclick="closeBookingModal()"
                            class="px-8 py-3 bg-slate-100 text-slate-600 font-semibold rounded-lg hover:bg-slate-200 transition-colors text-sm">
                            Cancel Booking
                        </button>
                        <button type="submit"
                            class="px-10 py-3 bg-primary-container text-white font-semibold rounded-lg shadow-lg shadow-primary/20 hover:bg-primary transition-all active:scale-95 duration-100 flex items-center gap-2 text-sm">
                            Confirm Appointment
                            <span class="material-symbols-outlined text-[18px]">arrow_forward</span>
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <%-- ══════════════════════════════════════════
         SIDEBAR
    ══════════════════════════════════════════ --%>
    <aside class="fixed h-screen w-[260px] left-0 top-0 bg-[#0052FF] text-white shadow-2xl shadow-blue-500/20 flex flex-col py-6 z-50 overflow-y-auto">
        <div class="px-8 mb-8">
            <h1 class="text-2xl font-black tracking-tight text-white uppercase">Upachaar</h1>
            <p class="text-[10px] uppercase tracking-widest text-white/60 font-bold">Patient Portal</p>
        </div>
        <nav class="flex-1 flex flex-col gap-1">
            <a class="text-white/70 hover:text-white mx-4 px-4 py-3 transition-all duration-200 flex items-center gap-3 hover:bg-white/10 rounded-full" href="dashboard.jsp">
                <span class="material-symbols-outlined">dashboard</span>
                <span class="text-sm font-medium">Dashboard</span>
            </a>
            <%-- Appointments - ACTIVE --%>
            <a class="bg-white text-[#0052FF] rounded-full mx-4 px-4 py-3 font-semibold transition-all duration-200 flex items-center gap-3 shadow-lg shadow-black/10" href="history.jsp">
                <span class="material-symbols-outlined">history</span>
                <span class="text-sm font-medium">Appointments</span>
            </a>
            <a class="text-white/70 hover:text-white mx-4 px-4 py-3 transition-all duration-200 flex items-center gap-3 hover:bg-white/10 rounded-full" href="messages.jsp">
                <span class="material-symbols-outlined">chat</span>
                <span class="text-sm font-medium">Messages</span>
            </a>
            <a class="text-white/70 hover:text-white mx-4 px-4 py-3 transition-all duration-200 flex items-center gap-3 hover:bg-white/10 rounded-full" href="settings.jsp">
                <span class="material-symbols-outlined">settings</span>
                <span class="text-sm font-medium">Settings</span>
            </a>
        </nav>
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

    <%-- ══════════════════════════════════════════
         MAIN CONTENT
    ══════════════════════════════════════════ --%>
    <main class="ml-[260px] min-h-screen relative pb-20">
        <header class="fixed top-0 right-0 w-[calc(100%-260px)] z-40 bg-white/80 backdrop-blur-md border-b border-slate-200 shadow-sm flex justify-between items-center px-8 h-16">
            <div class="flex items-center gap-4">
                <h1 class="text-xl font-bold text-slate-900">Appointment History</h1>
                <span class="text-slate-400">|</span>
                <span id="headerDate" class="font-medium text-slate-600"></span>
            </div>
            <div class="flex items-center gap-4 text-slate-500">
                <button class="hover:bg-slate-50 p-2 rounded-lg transition-colors">
                    <span class="material-symbols-outlined">notifications</span>
                </button>
                <button class="hover:bg-slate-50 p-2 rounded-lg transition-colors">
                    <span class="material-symbols-outlined">account_circle</span>
                </button>
            </div>
        </header>

        <div class="pt-24 px-8 pb-12 max-w-5xl mx-auto">
            <div class="flex justify-between items-center mb-8">
                <div>
                    <h2 class="text-2xl font-bold text-slate-900">Your Appointments</h2>
                    <p class="text-sm text-slate-500 mt-1">Manage and review your past and upcoming clinic visits.</p>
                </div>
                <button onclick="openBookingModal()"
                    class="px-6 py-3 bg-primary-container text-white font-button rounded-lg shadow-lg shadow-primary/20 hover:bg-primary transition-all active:scale-95 duration-100 flex items-center gap-2">
                    <span class="material-symbols-outlined text-[20px]">add_circle</span>
                    Book New Appointment
                </button>
            </div>
            <div class="space-y-4">

                <c:choose>

                    <c:when test="${not empty appointments}">

                        <c:forEach var="appointment" items="${appointments}">

                            <div class="bg-white rounded-xl p-6 shadow-sm border border-slate-200 flex flex-col md:flex-row justify-between items-center gap-6 transition-all hover:shadow-md">

                                    <%-- Left Side --%>
                                <div class="flex items-center gap-5 w-full md:w-auto">

                                        <%-- Status Icon --%>
                                    <div class="w-14 h-14 rounded-full
                            ${appointment.status == 'completed' ? 'bg-emerald-50 text-emerald-600' : 'bg-blue-50 text-primary-container'}
                            flex items-center justify-center">

                            <span class="material-symbols-outlined text-[28px]">
                                    ${appointment.status == 'completed' ? 'check_circle' : 'schedule'}
                            </span>
                                    </div>

                                        <%-- Appointment Info --%>
                                    <div>

                                        <h3 class="font-bold text-lg text-slate-900">
                                                ${appointment.doctorName}
                                        </h3>

                                        <p class="text-sm text-slate-500 font-medium">
                                                ${appointment.department}
                                        </p>

                                        <div class="text-sm text-slate-600 flex items-center gap-2 mt-2 font-medium bg-slate-50 px-3 py-1.5 rounded-lg w-fit">

                                <span class="material-symbols-outlined text-[16px] text-slate-400">
                                    calendar_today
                                </span>

                                                ${appointment.appointmentDate}

                                        </div>

                                        <div class="mt-2 text-sm text-slate-500">
                                            Reason: ${appointment.reason}
                                        </div>

                                    </div>
                                </div>

                                    <%-- Right Side --%>
                                <div class="flex items-center gap-4 w-full md:w-auto justify-end">

                                        <%-- Status Badge --%>
                                    <span class="px-3 py-1.5
                            ${appointment.status == 'completed'
                                ? 'bg-emerald-100 text-emerald-700'
                                : 'bg-blue-100 text-blue-700'}
                            text-xs font-bold rounded-md uppercase tracking-wider">

                                            ${appointment.status}

                                    </span>

                                        <%-- Review Button for Completed Appointments --%>
                                    <c:if test="${appointment.status == 'completed'}">

                                        <button
                                                onclick="openReviewModal('${appointment.doctorName}')"
                                                class="px-4 py-2 border border-primary-container text-primary-container rounded-lg hover:bg-primary-container/10 transition-colors text-sm font-bold flex items-center gap-2">

                                <span class="material-symbols-outlined text-[18px]">
                                    rate_review
                                </span>

                                            Review
                                        </button>

                                    </c:if>

                                </div>

                            </div>

                        </c:forEach>

                    </c:when>

                    <%-- No Appointments --%>
                    <c:otherwise>

                        <div class="bg-white rounded-xl p-10 text-center border border-slate-200 shadow-sm">

                <span class="material-symbols-outlined text-[60px] text-slate-300 mb-4">
                    event_busy
                </span>

                            <h3 class="text-xl font-bold text-slate-700 mb-2">
                                No Appointments Found
                            </h3>

                            <p class="text-slate-500">
                                You have not booked any appointments yet.
                            </p>

                        </div>

                    </c:otherwise>

                </c:choose>

            </div>
        </div>

        <footer class="absolute bottom-0 w-full py-6 border-t border-slate-200 bg-slate-50 flex justify-between items-center px-8">
            <div class="text-xs uppercase tracking-widest text-slate-400">&copy; 2024 Upachaar Clinical Systems. Precision &amp; Reliability.</div>
            <div class="flex gap-6">
                <a class="text-xs uppercase tracking-widest text-slate-400 hover:text-slate-600 transition-colors hover:underline" href="privacy.jsp">Privacy Policy</a>
                <a class="text-xs uppercase tracking-widest text-slate-400 hover:text-slate-600 transition-colors hover:underline" href="terms.jsp">Terms of Service</a>
            </div>
        </footer>
    </main>

    <script>
        /* ── Header date ── */
        const MONTH_NAMES = ["January","February","March","April","May","June","July","August","September","October","November","December"];
        const DAY_NAMES   = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"];
        const today = new Date();
        today.setHours(0,0,0,0);
        document.getElementById('headerDate').textContent =
            DAY_NAMES[today.getDay()] + ', ' + MONTH_NAMES[today.getMonth()] + ' ' + today.getDate() + ', ' + today.getFullYear();

        /* ── Booking Modal ── */
        function openBookingModal() {
            document.getElementById('bookingModal').classList.remove('hidden');
            document.body.style.overflow = 'hidden';
            renderCalendar();
        }

        function closeBookingModal() {
            document.getElementById('bookingModal').classList.add('hidden');
            document.body.style.overflow = '';
        }

        // Close on backdrop click
        document.getElementById('bookingModal').addEventListener('click', function(e) {
            if (e.target === this) closeBookingModal();
        });

        /* ── Booking State ── */
        const bookingState = {
            department: "Cardiology Specialist Center",
            doctorId: 1,
            doctorName: "Dr. Arjun Mehta",
            sqlDate: "",
            displayDate: "—",
            time: "—",
            fee: "120"
        };

        /* ── Calendar ── */
        let calYear  = today.getFullYear();
        let calMonth = today.getMonth();

        function pad2(n){ return String(n).padStart(2,'0'); }

        function renderCalendar() {
            document.getElementById('calMonthLabel').textContent = MONTH_NAMES[calMonth] + ' ' + calYear;
            const grid = document.getElementById('calGrid');
            const headers = Array.from(grid.children).slice(0, 7);
            grid.innerHTML = '';
            headers.forEach(h => grid.appendChild(h));

            const firstDow    = new Date(calYear, calMonth, 1).getDay();
            const daysInMonth = new Date(calYear, calMonth + 1, 0).getDate();

            for (let i = 0; i < firstDow; i++) {
                grid.appendChild(document.createElement('div'));
            }

            for (let d = 1; d <= daysInMonth; d++) {
                const cell     = document.createElement('div');
                const cellDate = new Date(calYear, calMonth, d);
                const iso      = calYear + '-' + pad2(calMonth + 1) + '-' + pad2(d);
                const display  = MONTH_NAMES[calMonth].slice(0,3) + ' ' + d + ', ' + calYear;

                cell.textContent     = d;
                cell.dataset.date    = iso;
                cell.dataset.display = display;

                const isPast  = cellDate < today;
                const isToday = cellDate.getTime() === today.getTime();
                const isSelected = bookingState.sqlDate === iso;

                if (isPast) {
                    cell.className = 'date-cell p-2 text-xs font-semibold text-slate-300 cursor-not-allowed select-none';
                } else if (isSelected) {
                    cell.className = 'date-cell p-2 text-xs font-bold bg-primary-container text-white rounded-lg shadow-md shadow-primary/20 cursor-pointer';
                    cell.onclick = () => selectDate(cell);
                } else if (isToday) {
                    cell.className = 'date-cell p-2 text-xs font-bold border-2 border-primary-container text-primary rounded-lg cursor-pointer hover:bg-primary-container/10 transition-all';
                    cell.onclick = () => selectDate(cell);
                } else {
                    cell.className = 'date-cell p-2 text-xs font-semibold hover:bg-primary-container/10 rounded-lg cursor-pointer transition-all';
                    cell.onclick = () => selectDate(cell);
                }

                grid.appendChild(cell);
            }

            const prevBtn = document.getElementById('calPrev');
            const atMin   = calYear === today.getFullYear() && calMonth === today.getMonth();
            prevBtn.disabled = atMin;
            prevBtn.classList.toggle('opacity-30', atMin);
            prevBtn.classList.toggle('cursor-not-allowed', atMin);
        }

        document.getElementById('calPrev').addEventListener('click', function() {
            if (this.disabled) return;
            calMonth--;
            if (calMonth < 0) { calMonth = 11; calYear--; }
            renderCalendar();
        });

        document.getElementById('calNext').addEventListener('click', function() {
            calMonth++;
            if (calMonth > 11) { calMonth = 0; calYear++; }
            renderCalendar();
        });

        /* ── Doctor / Date / Time ── */
        function setActive(elements, activeElement, activeClasses, inactiveClasses) {
            elements.forEach(el => {
                el.classList.remove(...activeClasses);
                el.classList.add(...inactiveClasses);
            });
            activeElement.classList.remove(...inactiveClasses);
            activeElement.classList.add(...activeClasses);
        }

        function selectDoctor(card) {
            bookingState.doctorId   = card.dataset.id;
            bookingState.doctorName = card.dataset.name;
            bookingState.department = card.dataset.department || bookingState.department;
            bookingState.fee        = card.dataset.fee || bookingState.fee;
            const deptSelect = document.getElementById('departmentSelect');
            if (deptSelect) deptSelect.value = bookingState.department;
            const cards = document.querySelectorAll('.doctor-card');
            setActive(cards, card, ['border-2','border-primary-container','bg-primary/5'], ['border','border-outline-variant']);
            syncBookingSummary();
        }

        function selectDate(cell) {
            bookingState.sqlDate     = cell.dataset.date;
            bookingState.displayDate = cell.dataset.display;
            renderCalendar();
            syncBookingSummary();
        }

        function selectTime(btn) {
            if (btn.disabled) return;
            bookingState.time = btn.dataset.time || btn.textContent.trim();
            const buttons = document.querySelectorAll('.time-slot:not([disabled])');
            setActive(buttons, btn,
                ['bg-primary-container','text-white','border-primary-container','shadow-lg','shadow-primary/20'],
                ['bg-surface-variant/30','text-inherit','border-outline-variant']
            );
            syncBookingSummary();
        }

        function syncBookingSummary() {
            document.getElementById('summaryDoctor').textContent = bookingState.doctorName;
            document.getElementById('summaryDate').textContent   = bookingState.displayDate;
            document.getElementById('summaryTime').textContent   = bookingState.time;
            document.getElementById('summaryFee').textContent    = '$' + bookingState.fee + '.00';
            document.getElementById('hiddenDoctorId').value        = bookingState.doctorId;
            document.getElementById('hiddenAppointmentDate').value = bookingState.sqlDate;
            document.getElementById('hiddenAppointmentTime').value = bookingState.time;
        }

        /* ── Review Modal ── */
        let currentRating = 0;

        function openReviewModal(doctorName) {
            document.getElementById('reviewDoctorName').textContent = doctorName;
            document.getElementById('reviewText').value = '';
            currentRating = 0;
            updateStars(0);
            document.getElementById('reviewModal').classList.remove('hidden');
        }

        function closeReviewModal() {
            document.getElementById('reviewModal').classList.add('hidden');
        }

        function submitReview() {
            alert('Review submitted successfully!');
            closeReviewModal();
        }

        document.querySelectorAll('#starRating .star').forEach(star => {
            star.addEventListener('click', () => {
                currentRating = parseInt(star.dataset.val);
                updateStars(currentRating);
            });
            star.addEventListener('mouseenter', () => updateStars(parseInt(star.dataset.val)));
            star.addEventListener('mouseleave', () => updateStars(currentRating));
        });

        function updateStars(rating) {
            document.querySelectorAll('#starRating .star').forEach(s => {
                const val = parseInt(s.dataset.val);
                if (val <= rating) {
                    s.style.fontVariationSettings = "'FILL' 1";
                    s.classList.remove('text-slate-300');
                    s.classList.add('text-yellow-400');
                } else {
                    s.style.fontVariationSettings = "'FILL' 0";
                    s.classList.remove('text-yellow-400');
                    s.classList.add('text-slate-300');
                }
            });
        }
    </script>
</body>
</html>
