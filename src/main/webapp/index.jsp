<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    // Mocking backend data for dynamic JSP rendering
    request.setAttribute("hospitalName", "Upachar");
    request.setAttribute("phone", "1-213-456-7899");
    request.setAttribute("year", "2024");

    // Statistics
    request.setAttribute("patientsServed", "12K+");
    request.setAttribute("expertDoctors", "50+");
    request.setAttribute("healingSuccess", "84%");

    // Services Array: {icon, title, description}
    String[][] services = {
            {"folder_shared", "Patient Records", "Secure, centralized access to complete medical histories and electronic health records."},
            {"calendar_month", "Easy Scheduling", "Intelligent calendar systems for booking appointments and managing doctor availability."},
            {"receipt_long", "Billing", "Automated invoicing, insurance claims processing, and transparent financial tracking."},
            {"forum", "Real-time Chat", "Instant, secure communication channels between medical staff, administrators, and patients."}
    };
    request.setAttribute("services", services);

    // Team Array: {imageUrl, name, role, altText}
    String[][] teamMembers = {
            {"https://lh3.googleusercontent.com/aida-public/AB6AXuDRMnmP4h4oGwVML7jkPT22FhHDw4J543D9RNZfj7mVQnvYfOFyCp3_OyfV0yAKBF-Os7AbMY_XemnN8n8pIh-PkUxrV0tEFb4fctLBD_K82shj5h0D6lyQ6bXaAXip6EO4hJhXLnFHqigkQX6kbW4evsO3gOuFvzOL5t68ENyBG9ior-iHFqtQxGHMhxVf0gtwmUdNqT6rPNmWYME2lCRDRcpmxJdioyd0O_zWzwnZqrV8gyHQT7e9I4dZT1cQBjZpRSUPFPfyBh28", "Dr. Alex Rivera", "Senior Surgeon", "Dr. Alex Rivera"},
            {"https://lh3.googleusercontent.com/aida-public/AB6AXuA5WQCoDARTYtb96YBXze6kTv_SMkGxjETlrOjrdBFHDUOI9VRcgzSELovqpyIwCjGZAH2lyIN-YnhHyMxTTustCCBpLhHrbcIiBEAzSJze6pZ6khAXNQAWIkNXFr_QnF1NAEeED9QiwLmAp7Le1JWtc-WBSEy2L9_lvcYwp9b4ENOFFsORG4XDh2sPkenKdbX1isF4Cqq6rud9Kgb6-TwFHtvvJDPz2YnMU9bFrZsJEGyE_IX2VKZgWSVR-x7fXnxMnuPuyTqVkHNQ", "Dr. Sarah Chen", "Chief Cardiologist", "Dr. Sarah Chen"},
            {"https://lh3.googleusercontent.com/aida-public/AB6AXuBd9cPFVQ-O5Z8Y1Gbqh0swl1MeVrrxqAXrm4kHdrbSS6wGbpszrY2v1Gv94lmDv2miCTD2UPx3DF1cv9BGvGK7h6goHY7KY3bVaumhsguir58ZWncWXSTF7PXFVdhGF-OBy4ynCZwvq-hABl6PUXepQsYEn7Z-UAigGmxRTUe0IDsgoMtyh2vI520fkRpmWYIfUFKXZvaSml8uzE0sr6N3ctGgFeNF1QAzpsHcZNe1GsBLqV9pYpevWdTRbiVho51cBd_NL2WprmYR", "Maria Garcia", "Head Nurse", "Nurse Maria Garcia"},
            {"https://lh3.googleusercontent.com/aida-public/AB6AXuB7gVOYlJVsQBwUb33tS8ES6mO2S09-ESZUv1h23N_wH5CdiCm0cWQPhi4ML0c_GgJz_RsBYxykabSe1Pevsn0Ui771TzAoviY6bjdndk0jjBsAcLdw6J4rHrsI2DZgACMnhwsEhzczxi3HLFqPGFAPcBOwESOj91XaPvMb6rFnSfzuUBrgtW1HjmGjy28PLkqERZYdozcJlV7SiXK8w95FhM4_r2alDTwYuGjlXsNK-i2c1JM5QSf4fqk-zELb4yYe3_1owzhL93D_", "Dr. James Wilson", "Pediatrician", "Dr. James Wilson"}
    };
    request.setAttribute("teamMembers", teamMembers);
%>
<!DOCTYPE html>
<html class="light" lang="en"><head>
    <meta charset="utf-8"/>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <title>${hospitalName} Hospital Management System</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500&family=Inter+Tight:wght@700;800;900&family=Manrope:wght@600;700&family=Public+Sans:wght@600&display=swap" rel="stylesheet"/>
    <script id="tailwind-config">tailwind.config = {
        darkMode: "class",
        theme: {
            extend: {
                "colors": {
                    "on-error-container": "#93000a",
                    "surface-variant": "#e7e1dd",
                    "secondary-fixed": "#c1e8fc",
                    "primary-fixed": "#d1e4ff",
                    "on-tertiary-container": "#9daeba",
                    "on-background": "#1d1b19",
                    "surface-container-low": "#f8f2ee",
                    "on-tertiary": "#ffffff",
                    "background": "#fef8f4",
                    "tertiary": "#1c2c36",
                    "tertiary-fixed": "#d4e5f2",
                    "outline": "#74777d",
                    "surface-tint": "#4e6076",
                    "on-secondary-fixed": "#001f29",
                    "surface-container-lowest": "#ffffff",
                    "on-tertiary-fixed": "#0d1d27",
                    "error-container": "#ffdad6",
                    "secondary": "#3d6374",
                    "on-surface": "#1d1b19",
                    "inverse-surface": "#32302e",
                    "error": "#ba1a1a",
                    "primary-fixed-dim": "#b5c8e2",
                    "on-secondary-container": "#426878",
                    "surface-container-highest": "#e7e1dd",
                    "tertiary-fixed-dim": "#b8c9d6",
                    "surface-container-high": "#ede7e3",
                    "surface": "#fef8f4",
                    "inverse-on-surface": "#f6f0ec",
                    "on-primary-fixed": "#081d30",
                    "surface-container": "#f3ede9",
                    "on-error": "#ffffff",
                    "on-tertiary-fixed-variant": "#394953",
                    "on-secondary": "#ffffff",
                    "secondary-fixed-dim": "#a5ccdf",
                    "primary": "#182b3f",
                    "on-surface-variant": "#44474c",
                    "inverse-primary": "#b5c8e2",
                    "on-primary-container": "#9aadc6",
                    "primary-container": "#2f4156",
                    "on-primary": "#ffffff",
                    "outline-variant": "#c4c6cd",
                    "tertiary-container": "#32424c",
                    "on-secondary-fixed-variant": "#244c5b",
                    "secondary-container": "#bee6f9",
                    "surface-dim": "#dfd9d5",
                    "surface-bright": "#fef8f4",
                    "on-primary-fixed-variant": "#36485d"
                },
                "borderRadius": {
                    "DEFAULT": "0.25rem",
                    "lg": "0.5rem",
                    "xl": "0.75rem",
                    "full": "9999px"
                },
                "spacing": {
                    "xl": "56px",
                    "sm": "14px",
                    "margin": "32px",
                    "md": "24px",
                    "lg": "40px",
                    "gutter": "32px",
                    "base": "8px",
                    "xs": "4px"
                },
                "fontFamily": {
                    "body-lg": ["Inter"],
                    "headline-lg": ["Manrope"],
                    "label-md": ["Public Sans"],
                    "body-md": ["Inter"],
                    "button": ["Inter"],
                    "headline-md": ["Manrope"],
                    "body-sm": ["Inter"],
                    "headline-sm": ["Manrope"]
                },
                "fontSize": {
                    "body-lg":    ["18px", { "lineHeight": "28px", "fontWeight": "400" }],
                    "headline-lg":["44px", { "lineHeight": "54px", "fontWeight": "700" }],
                    "label-md":   ["14px", { "lineHeight": "20px", "letterSpacing": "0.02em", "fontWeight": "600" }],
                    "body-md":    ["17px", { "lineHeight": "27px", "fontWeight": "400" }],
                    "button":     ["17px", { "lineHeight": "27px", "fontWeight": "500" }],
                    "headline-md":["28px", { "lineHeight": "38px", "fontWeight": "600" }],
                    "body-sm":    ["15px", { "lineHeight": "23px", "fontWeight": "400" }],
                    "headline-sm":["22px", { "lineHeight": "30px", "fontWeight": "600" }]
                }
            }
        }
    }</script>
</head>
<body class="bg-white text-on-background min-h-screen flex flex-col font-body-md text-body-md antialiased">

<!-- NAV -->
<nav class="bg-white/90 dark:bg-slate-900/90 backdrop-blur-md font-['Manrope'] font-semibold tracking-tight top-0 sticky z-50 border-b border-[#C8D9E6]/30 dark:border-slate-800 shadow-sm shadow-[#2F4156]/5">
    <div class="flex justify-between items-center w-full px-8 py-4 max-w-7xl mx-auto">
        <div class="font-bold text-[#2F4156] dark:text-white tracking-tight text-3xl">
            ${hospitalName}
        </div>
        <div class="hidden md:flex gap-8 items-center text-lg">
            <a class="text-[#567C8D] dark:text-[#C8D9E6] hover:bg-slate-50 dark:hover:bg-slate-800/50 px-2 py-1 rounded transition-all" href="#">Home</a>
            <a class="text-[#2F4156] dark:text-slate-400 hover:text-[#567C8D] hover:bg-slate-50 dark:hover:bg-slate-800/50 px-2 py-1 rounded transition-all" href="#">About</a>
            <a class="text-[#2F4156] dark:text-slate-400 hover:text-[#567C8D] hover:bg-slate-50 dark:hover:bg-slate-800/50 px-2 py-1 rounded transition-all" href="#">Services</a>
            <a class="text-[#2F4156] dark:text-slate-400 hover:text-[#567C8D] hover:bg-slate-50 dark:hover:bg-slate-800/50 px-2 py-1 rounded transition-all" href="#">Contact</a>
        </div>
        <div class="flex gap-3">
            <a href="login.jsp" class="inline-block text-center bg-white text-[#2F4156] border-2 border-[#2F4156] font-semibold px-7 py-3 rounded-full hover:bg-[#e8edf2] active:bg-[#d0d9e3] transition-colors shadow-sm text-lg">
                Login
            </a>
            <a href="register.jsp" class="inline-block text-center bg-[#2F4156] text-white font-semibold px-7 py-3 rounded-full hover:bg-[#1e2e3d] active:bg-[#131f2a] transition-colors shadow-lg text-lg">
                Create an Account
            </a>
        </div>
    </div>
</nav>

<main class="flex-grow flex flex-col gap-10 py-10 px-gutter max-w-7xl mx-auto w-full">

    <!-- HERO -->
    <section class="bg-[#F0F4F8] rounded-2xl p-10 shadow-[0_8px_30px_rgba(47,65,86,0.08)] flex flex-col lg:flex-row gap-10 items-center relative overflow-hidden">
        <div class="absolute -top-24 -right-24 w-96 h-96 bg-secondary-container rounded-full blur-3xl opacity-40 -z-10"></div>
        <div class="flex-1 flex flex-col gap-5 z-10">
            <h1 class="font-['Inter_Tight'] text-headline-lg text-primary-container font-black leading-tight">
                Empowering Healthcare<br>with ${hospitalName}
            </h1>
            <p class="font-body-lg text-body-lg text-on-surface-variant max-w-lg">
                A modern hospital management system designed to streamline patient records, simplify scheduling, and enhance clinical workflows.
            </p>
            <div class="mt-2">
                <button class="bg-secondary text-on-primary font-button text-button px-8 py-3 rounded-full hover:brightness-110 transition-all shadow-md shadow-secondary/20">
                    Book an Appointment
                </button>
            </div>
        </div>
        <div class="flex-1 w-full h-[380px] relative rounded-xl overflow-hidden shadow-sm shadow-primary-container/5 bg-surface-container-low flex items-center justify-center">
            <img alt="Medical professionals collaborating" class="object-cover w-full h-full opacity-90" src="https://lh3.googleusercontent.com/aida-public/AB6AXuCnff0IvPY868bqNssIZ6Z0GybJavhGplzsr3kq8eZjzLKi38C32f5VuSS4wdCunPBIFx07cPCVVhgN_OYee7dWWPEGt4J4g2nBijiYPZ-E-ugcG3Ce-EfKdb9QzcSodKqVdWaroJyvlTKe-R5UZ8gWVOX3c-gJbucdd7oZ1Pm7r1A8tbbbzIfNNUyU4s_ro5aaBmXCVpZc0iU48q1f_u2Ja2lwSAGTuiHDuqZ56wRK0RgwKQrMAX45UB6mlLjH2HBxYxVhcKQFbgdY"/>
        </div>
    </section>

    <!-- STATS -->
    <section class="grid grid-cols-1 md:grid-cols-4 gap-md">
        <div class="md:col-span-1 flex items-center">
            <p class="font-headline-sm italic text-secondary leading-tight text-xl">
                "Health is the greatest wealth."
            </p>
        </div>
        <div class="bg-white rounded-[2rem] p-6 flex flex-col items-center justify-center text-center shadow-xl border border-surface-container-high">
            <div class="flex -space-x-3 mb-4">
                <img alt="User 1" class="w-9 h-9 rounded-full border-2 border-white object-cover" src="https://lh3.googleusercontent.com/aida-public/AB6AXuDyW8yfz6aPcYjghVSZpAQEttb8kVB4gb2mFlq3Cx1DhsfbNyH5CyIgcDuzCD1r2Z4h2W072zZpBNqCeTxADNu7BILopXWiy5vH9YlDAgRAyZu4EPZrqxRUvz_MmMCXQIanbpjYq5PgmIWo1_wHE1xIn6TAZ4ABF6AqXyHEYX0ZuXs5xglbZhcgt4lZ9YM_Fla5RSnOyhb_KYC1M7a8GrE7vgn7rPBTn67J-uu79htKA7GdSJa9dwbQaV-XcD9qzW8zmhxlp-__j3li"/>
                <img alt="User 2" class="w-9 h-9 rounded-full border-2 border-white object-cover" src="https://lh3.googleusercontent.com/aida-public/AB6AXuDZB-GU225HwFnUOCIJG0s3bN7ceZbxvM4H3DIZJdVc08tcoxk2rrXy_iBFWGxy4fMieAkhFh5dDJHSi982lVffWO9D41kvJEnu8KTT_0ylVqtWclEHA592CltZpUmsssEWjerdup5_9iJ9DqNsXMDGzVCODHYefDM2JyHHdzR1nM9pXfTP3WDIDW48QQw_u-95tTScmWF42tpWVcUEdBMlAj3scITwFXoCx_bVecrLWy1CS2JjKkLrcJRbqJtTWtJmLx-zHm7y8K_h"/>
                <img alt="User 3" class="w-9 h-9 rounded-full border-2 border-white object-cover" src="https://lh3.googleusercontent.com/aida-public/AB6AXuDb4iWRzlRLNo1iTXVaO9gS9YBXvvIh7kkukJrpBLiJLHd22MTbrGJpjkQpQC1CBFF-Zwp0fgseXLm2AtpfMEEv8gSd-FbVVz1aJkdDkz-CrYHv5QBTMHb-mLS4ctwSWR7sOU3ClgguCOCOr-K4pjj1Ymw8HpoGmTPIvhAQE925wwvE1IsKU5Dy1UyzY53DiuCsHXdBsXj6i0jSeGN-JT7MW0-6Ih9yEDSXCwdXGSMLHV8alkBVutJJbGFLpRtFGWFmvy98Tumsr71l"/>
            </div>
            <span class="font-headline-lg text-[#567C8D] leading-none text-4xl font-bold">${patientsServed}</span>
            <span class="font-label-md text-on-surface-variant mt-2 uppercase tracking-wider text-xs">Patients Served</span>
        </div>
        <div class="bg-white rounded-[2rem] p-6 flex flex-col items-center justify-center text-center shadow-xl border border-surface-container-high">
            <div class="w-10 h-10 rounded-full bg-secondary-container flex items-center justify-center text-secondary mb-4">
                <span class="material-symbols-outlined text-2xl">medical_services</span>
            </div>
            <span class="font-headline-lg text-[#567C8D] leading-none text-4xl font-bold">${expertDoctors}</span>
            <span class="font-label-md text-on-surface-variant mt-2 uppercase tracking-wider text-xs">Expert Doctors</span>
        </div>
        <div class="bg-white rounded-[2rem] p-6 flex flex-col items-center justify-center text-center shadow-xl border border-surface-container-high">
            <div class="relative w-24 h-24 mb-3 flex items-center justify-center">
                <svg class="absolute w-full h-full transform -rotate-90" viewBox="0 0 100 100">
                    <circle cx="50" cy="50" fill="none" r="40" stroke="#e2e8f0" stroke-width="8"></circle>
                    <circle cx="50" cy="50" fill="none" r="40" stroke="#567C8D" stroke-dasharray="251.2" stroke-dashoffset="40.2" stroke-linecap="round" stroke-width="8"></circle>
                </svg>
                <span class="font-headline-md text-primary-container relative z-10 text-xl font-bold">${healingSuccess}</span>
            </div>
            <span class="font-label-md text-on-surface-variant uppercase tracking-wider text-xs">Healing Success</span>
        </div>
    </section>

    <!-- SERVICES -->
    <section class="flex flex-col gap-6 mt-4">
        <div class="text-center max-w-2xl mx-auto">
            <h2 class="font-['Inter_Tight'] text-primary-container font-black text-3xl leading-tight">Comprehensive Medical Solutions</h2>
            <p class="font-body-md text-body-md text-on-surface-variant mt-2">Integrated tools to manage every aspect of hospital administration with ease and precision.</p>
        </div>
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-md">
            <c:forEach var="service" items="${services}">
                <div class="bg-[#F0F4F8] rounded-2xl p-5 shadow-[0_4px_25px_rgba(47,65,86,0.06)] flex flex-col gap-3 hover:-translate-y-1 transition-transform duration-300">
                    <div class="w-10 h-10 rounded-full bg-secondary-container flex items-center justify-center text-secondary">
                        <span class="material-symbols-outlined text-xl" style='font-variation-settings: "FILL" 1;'>${service[0]}</span>
                    </div>
                    <h3 class="font-headline-sm text-headline-sm text-primary-container">${service[1]}</h3>
                    <p class="font-body-sm text-body-sm text-on-surface-variant">${service[2]}</p>
                </div>
            </c:forEach>
        </div>
    </section>

    <!-- ABOUT / QUALITY -->
    <section class="flex flex-col lg:flex-row gap-10 mt-4 items-center">
        <div class="flex-1 flex flex-col gap-4">
            <span class="font-label-md text-secondary uppercase tracking-wider text-xs">Our Practice</span>
            <h2 class="font-['Inter_Tight'] text-primary-container font-black text-3xl leading-tight">We provide top quality healthcare.</h2>
            <p class="font-body-md text-body-md text-on-surface-variant">
                We are dedicated to offering world-class medical services with a compassionate touch. Our modern facilities and expert professionals ensure that you receive the best care possible.
            </p>
            <div class="flex flex-col gap-4 mt-2">
                <div class="flex gap-4 items-start">
                    <div class="w-12 h-12 rounded-full bg-secondary-container flex-shrink-0 flex items-center justify-center text-secondary">
                        <span class="material-symbols-outlined text-2xl">medical_services</span>
                    </div>
                    <div>
                        <h3 class="font-headline-sm text-primary-container text-base font-semibold">Highly Professional Staff</h3>
                        <p class="font-body-sm text-body-sm text-on-surface-variant mt-1">Expert medical practitioners dedicated to your well-being and speedy recovery.</p>
                    </div>
                </div>
                <div class="flex gap-4 items-start">
                    <div class="w-12 h-12 rounded-full bg-secondary-container flex-shrink-0 flex items-center justify-center text-secondary">
                        <span class="material-symbols-outlined text-2xl">fact_check</span>
                    </div>
                    <div>
                        <h3 class="font-headline-sm text-primary-container text-base font-semibold">Quality Control Systems</h3>
                        <p class="font-body-sm text-body-sm text-on-surface-variant mt-1">Rigorous protocols ensuring the highest standards of safety, hygiene, and care.</p>
                    </div>
                </div>
            </div>
        </div>
        <div class="flex-1 relative w-full flex justify-center">
            <div class="w-[85%] max-w-[400px] aspect-[4/5] rounded-t-full rounded-bl-[3rem] rounded-br-2xl overflow-hidden shadow-[0_20px_50px_rgba(47,65,86,0.15)] relative">
                <img alt="Modern clinical room" class="w-full h-full object-cover" src="https://lh3.googleusercontent.com/aida-public/AB6AXuDeCINENLrZ9w4bt4zXlNbDl6Bo2MdEcp-C77ZZilr6g_tbZ5LDT3pxW6C7xpFotRIjIkZfD3xcai47dwYfpUJ9HOUmxG0AgxHFERZKOyOZVjSRhNrwhYqhtIJactS1SNUzTKDvrDP9Hru07ShexAEOeIzN1uTvpd9x5Kh0cYS6PpLvYNpDSjhgWVdUnOIGRKW7fAFkdHJzLQR5gsts4qeEH3blDRPhb6n4-vBZYDb9mres9AOuirssI9-B2uj76u5MuL4M_bdT50pG"/>
            </div>
            <div class="absolute bottom-6 right-0 md:-right-4 bg-primary-container text-white p-4 rounded-2xl shadow-xl flex items-center gap-3 border border-white/10 backdrop-blur-sm">
                <div class="w-10 h-10 rounded-full bg-secondary flex items-center justify-center shadow-inner flex-shrink-0">
                    <span class="material-symbols-outlined text-white text-xl">call</span>
                </div>
                <div>
                    <p class="font-label-md text-secondary-fixed tracking-wider uppercase text-xs">24/7 Emergency</p>
                    <p class="font-['Inter_Tight'] text-white text-sm font-bold tracking-tight">${phone}</p>
                </div>
            </div>
        </div>
    </section>

    <!-- 4 STEPS -->
    <section class="flex flex-col gap-6 mt-4 mb-6">
        <div class="text-center max-w-2xl mx-auto">
            <h2 class="font-['Inter_Tight'] text-primary-container font-black text-3xl leading-tight">4 Easy Steps To Get Your Solution</h2>
            <p class="font-body-md text-body-md text-on-surface-variant mt-2">Navigating health together — your trusted medical resource where medicine meets technology.</p>
        </div>
        <div class="relative border border-surface-container-high rounded-[2rem] bg-white flex flex-col md:flex-row shadow-sm">
            <div class="flex-1 p-6 flex flex-col items-center text-center">
                <div class="w-12 h-12 mb-3 flex items-center justify-center text-primary-container">
                    <span class="material-symbols-outlined text-4xl">person</span>
                </div>
                <h3 class="font-headline-sm text-headline-sm text-primary-container mb-2">Check Doctor Profile</h3>
                <p class="font-body-sm text-body-sm text-on-surface-variant">Browse expert profiles and find the right specialist for your needs.</p>
            </div>
            <div class="flex-1 p-6 flex flex-col items-center text-center bg-secondary text-white rounded-[2rem] shadow-xl md:-my-4 relative z-10">
                <div class="w-12 h-12 mb-3 flex items-center justify-center text-white">
                    <span class="material-symbols-outlined text-4xl">contact_support</span>
                </div>
                <h3 class="font-headline-sm text-headline-sm text-white mb-2">Request Consultation</h3>
                <p class="font-body-sm text-body-sm text-white/90">Submit your request and connect with your preferred doctor instantly.</p>
            </div>
            <div class="flex-1 p-6 flex flex-col items-center text-center">
                <div class="w-12 h-12 mb-3 flex items-center justify-center text-primary-container">
                    <span class="material-symbols-outlined text-4xl">calendar_month</span>
                </div>
                <h3 class="font-headline-sm text-headline-sm text-primary-container mb-2">Schedule Meeting</h3>
                <p class="font-body-sm text-body-sm text-on-surface-variant">Pick a convenient time slot that fits your busy schedule.</p>
            </div>
            <div class="flex-1 p-6 flex flex-col items-center text-center">
                <div class="w-12 h-12 mb-3 flex items-center justify-center text-primary-container">
                    <span class="material-symbols-outlined text-4xl">thumb_up</span>
                </div>
                <h3 class="font-headline-sm text-headline-sm text-primary-container mb-2">Get Your Solution</h3>
                <p class="font-body-sm text-body-sm text-on-surface-variant">Receive expert care, prescriptions, and follow-up from our team.</p>
            </div>
        </div>
    </section>

    <!-- TEAM -->
    <section class="flex flex-col gap-6 mt-4 mb-8">
        <div class="text-center max-w-2xl mx-auto">
            <h2 class="font-['Inter_Tight'] text-primary-container font-black text-3xl leading-tight">Meet Our Team</h2>
            <p class="font-body-md text-body-md text-on-surface-variant mt-2">Dedicated professionals providing world-class healthcare with compassion and expertise.</p>
        </div>
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-md">
            <c:forEach var="member" items="${teamMembers}">
                <div class="bg-white rounded-2xl overflow-hidden shadow-[0_8px_30px_rgba(47,65,86,0.05)] border border-surface-container-high transition-transform hover:-translate-y-2 duration-300">
                    <div class="aspect-[4/5] bg-surface-container-low">
                        <img alt="${member[3]}" class="w-full h-full object-cover" src="${member[0]}"/>
                    </div>
                    <div class="p-4 text-center">
                        <h3 class="font-headline-sm text-primary-container text-base font-semibold">${member[1]}</h3>
                        <p class="font-body-sm text-secondary font-medium mt-1 uppercase tracking-wide text-xs">${member[2]}</p>
                    </div>
                </div>
            </c:forEach>
        </div>
    </section>

</main>

<footer class="bg-slate-50 dark:bg-slate-950 font-['Manrope'] text-xs font-medium mt-auto border-t border-[#C8D9E6] dark:border-slate-800">
    <div class="flex flex-col md:flex-row justify-between items-center w-full px-8 py-8 max-w-7xl mx-auto gap-4 text-[#2F4156] dark:text-slate-300">
        <div class="font-black text-[#2F4156] dark:text-white text-xl">
            ${hospitalName}
        </div>
        <div class="flex flex-wrap justify-center gap-5 text-xs">
            <a class="text-slate-500 dark:text-slate-400 hover:text-[#2F4156] dark:hover:text-white underline transition-all" href="#">Privacy Policy</a>
            <a class="text-slate-500 dark:text-slate-400 hover:text-[#2F4156] dark:hover:text-white underline transition-all" href="#">Terms of Service</a>
            <a class="text-slate-500 dark:text-slate-400 hover:text-[#2F4156] dark:hover:text-white underline transition-all" href="#">Help Center</a>
            <a class="text-slate-500 dark:text-slate-400 hover:text-[#2F4156] dark:hover:text-white underline transition-all" href="#">Contact Us</a>
        </div>
        <div class="text-slate-500 dark:text-slate-400 text-xs">
            © ${year} ${hospitalName} Hospital Management. All rights reserved.
        </div>
    </div>
</footer>
</body></html>
