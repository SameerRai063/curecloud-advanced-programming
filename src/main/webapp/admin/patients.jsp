<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Upachaar - Patient Management</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <style>
        :root {
            --primary-blue: #2554ff;
            --primary-teal: #0d7f6b;
            --bg-light: #f8fafc;
            --text-dark: #111827;
            --text-gray: #6b7280;
            --border-color: #e5e7eb;
            --sidebar-text-muted: #a0bafc;
            --table-header-bg: #e2f1ec;
            --table-header-text: #0b6b59;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Inter', sans-serif;
        }

        body {
            background-color: var(--bg-light);
            color: var(--text-dark);
            display: flex;
            height: 100vh;
            overflow: hidden;
        }

        /* --- Sidebar Styles --- */
        .sidebar {
            width: 250px;
            background-color: var(--primary-blue);
            color: white;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            flex-shrink: 0;
        }

        .sidebar-top {
            padding: 24px 16px;
        }

        .brand h1 {
            font-size: 22px;
            font-weight: 700;
            letter-spacing: 0.5px;
            margin-bottom: 4px;
        }

        .brand p {
            font-size: 12px;
            color: var(--sidebar-text-muted);
            margin-bottom: 32px;
        }

        .nav-menu {
            list-style: none;
        }

        .nav-item {
            margin-bottom: 4px;
        }

        .nav-link {
            display: flex;
            align-items: center;
            padding: 12px 16px;
            color: white;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            border-radius: 8px;
            transition: all 0.2s;
        }

        .nav-link i {
            width: 20px;
            margin-right: 12px;
            font-size: 16px;
            text-align: center;
        }

        .nav-item.active .nav-link {
            background-color: white;
            color: var(--primary-blue);
        }

        .nav-link:hover:not(.active) {
            background-color: rgba(255, 255, 255, 0.1);
        }

        .sidebar-bottom {
            padding: 20px 16px;
        }

        .social-links {
            margin-bottom: 24px;
            padding: 0 8px;
        }

        .social-links p {
            font-size: 11px;
            color: var(--sidebar-text-muted);
            margin-bottom: 8px;
        }

        .social-links i {
            margin-right: 12px;
            font-size: 14px;
            cursor: pointer;
            color: var(--sidebar-text-muted);
        }

        .user-profile {
            display: flex;
            align-items: center;
            padding-top: 16px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
        }

        .avatar {
            width: 36px;
            height: 36px;
            background-color: white;
            color: var(--primary-blue);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 14px;
            margin-right: 12px;
        }

        .user-info h4 {
            font-size: 13px;
            font-weight: 600;
        }

        .user-info p {
            font-size: 11px;
            color: var(--sidebar-text-muted);
        }

        /* --- Main Content Area --- */
        .main-wrapper {
            flex: 1;
            display: flex;
            flex-direction: column;
            overflow: hidden;
            position: relative;
        }

        /* --- Refined Header Styles --- */
        .topbar {
            height: 64px;
            background-color: white;
            border-bottom: 1px solid var(--border-color);
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 32px;
            flex-shrink: 0;
        }

        .topbar-left {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .topbar-left .title {
            font-size: 16px;
            font-weight: 600;
            color: var(--primary-teal);
        }

        .topbar-left .divider {
            color: #d1d5db;
        }

        .topbar-left .date {
            font-size: 13px;
            color: var(--text-gray);
        }

        .topbar-center {
            flex: 1;
            display: flex;
            justify-content: center;
        }

        .top-search {
            display: flex;
            align-items: center;
            background-color: #f3f4f6;
            border-radius: 20px;
            padding: 8px 16px;
            width: 400px;
        }

        .top-search i {
            color: #9ca3af;
            margin-right: 8px;
            font-size: 14px;
        }

        .top-search input {
            border: none;
            background: transparent;
            outline: none;
            width: 100%;
            font-size: 13px;
            color: var(--text-dark);
        }

        .top-search input::placeholder {
            color: #9ca3af;
        }

        .topbar-right {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .top-icon {
            font-size: 18px;
            color: var(--text-gray);
            cursor: pointer;
        }

        .btn-support {
            background-color: #f0fdf4;
            color: var(--primary-teal);
            border: 1px solid #bbf7d0;
            border-radius: 20px;
            padding: 6px 16px;
            font-size: 13px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s;
        }

        .btn-support:hover {
            background-color: #dcfce7;
        }

        /* --- Content Area Styles --- */
        .content {
            padding: 32px;
            overflow-y: auto;
            flex: 1;
            background-color: #fdfdfd;
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 24px;
        }

        .page-title h2 {
            font-size: 28px;
            font-weight: 700;
            color: #1a202c;
            margin-bottom: 4px;
        }

        .page-title p {
            font-size: 14px;
            color: var(--text-gray);
        }

        .btn-action {
            background-color: var(--primary-teal);
            color: white;
            border: none;
            border-radius: 8px;
            padding: 10px 20px;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            transition: opacity 0.2s;
            display: flex;
            align-items: center;
            gap: 8px;
            box-shadow: 0 2px 4px rgba(13, 127, 107, 0.2);
        }

        .btn-action:hover {
            opacity: 0.9;
        }

        /* --- Table Design --- */
        .table-container {
            background-color: white;
            border: 1px solid var(--border-color);
            border-radius: 12px;
            box-shadow: 0 1px 3px rgba(0,0,0,0.03);
            overflow: hidden;
        }

        .data-table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
        }

        .data-table th {
            background-color: var(--table-header-bg);
            padding: 16px 24px;
            font-size: 12px;
            font-weight: 700;
            color: var(--table-header-text);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .data-table td {
            padding: 16px 24px;
            font-size: 14px;
            color: var(--text-dark);
            border-bottom: 1px solid var(--border-color);
        }

        .empty-state {
            text-align: center;
            padding: 60px 20px !important;
            color: var(--text-gray);
            font-size: 14px;
        }

        /* --- Pagination --- */
        .pagination-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 16px 24px;
            border-top: 1px solid var(--border-color);
        }

        .pagination-info {
            font-size: 13px;
            color: var(--text-gray);
        }

        .pagination-controls {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .page-btn {
            width: 32px;
            height: 32px;
            display: flex;
            align-items: center;
            justify-content: center;
            border: none;
            background: transparent;
            border-radius: 4px;
            color: var(--text-gray);
            cursor: pointer;
            font-size: 14px;
        }

        .page-btn.active {
            background-color: var(--primary-teal);
            color: white;
        }

    </style>
</head>
<body>

<aside class="sidebar">
    <div class="sidebar-top">
        <div class="brand">
            <h1>Upachaar</h1>
            <p>Clinical Oversight</p>
        </div>

        <ul class="nav-menu">
            <li class="nav-item">
                <a href="dashboard.jsp" class="nav-link">
                    <i class="fa-solid fa-border-all"></i> Dashboard
                </a>
            </li>
            <li class="nav-item">
                <a href="doctors.jsp" class="nav-link">
                    <i class="fa-solid fa-stethoscope"></i> Doctors
                </a>
            </li>
            <li class="nav-item active">
                <a href="patients.jsp" class="nav-link">
                    <i class="fa-solid fa-users"></i> Patients
                </a>
            </li>
            <li class="nav-item">
                <a href="receptionists.jsp" class="nav-link">
                    <i class="fa-solid fa-user-nurse"></i> Receptionists
                </a>
            </li>
            <li class="nav-item">
                <a href="appointments.jsp" class="nav-link">
                    <i class="fa-regular fa-calendar"></i> Appointments
                </a>
            </li>
            <li class="nav-item">
                <a href="billing.jsp" class="nav-link">
                    <i class="fa-solid fa-file-invoice-dollar"></i> Billing
                </a>
            </li>
        </ul>
    </div>

    <div class="sidebar-bottom">
        <div class="social-links">
            <p>Follow us</p>
            <i class="fa-brands fa-facebook-f"></i>
            <i class="fa-brands fa-twitter"></i>
            <i class="fa-regular fa-envelope"></i>
        </div>

        <div class="user-profile">
            <div class="avatar">${not empty sessionScope.loggedInUser ? sessionScope.loggedInUser.name.substring(0,1) : 'S'}</div>
            <div class="user-info">
                <h4>${not empty sessionScope.loggedInUser ? sessionScope.loggedInUser.name : 'Samir'}</h4>
                <p>${not empty sessionScope.loggedInUser ? sessionScope.loggedInUser.role : 'Super Admin'}</p>
            </div>
        </div>
    </div>
</aside>

<div class="main-wrapper">

    <header class="topbar">
        <div class="topbar-left">
            <span class="title">Patients</span>
            <span class="divider">|</span>
            <span class="date">May 1, 2026</span>
        </div>
        <div class="topbar-center">
            <form action="searchPatients.jsp" method="GET" class="top-search">
                <i class="fa-solid fa-magnifying-glass"></i>
                <input type="text" name="query" placeholder="Search patients, records, or doctors...">
            </form>
        </div>
        <div class="topbar-right">
            <i class="fa-regular fa-bell top-icon"></i>
            <i class="fa-regular fa-circle-question top-icon"></i>
            <button class="btn-support">Support</button>
        </div>
    </header>

    <main class="content">

        <div class="page-header">
            <div class="page-title">
                <h2>Patient Management</h2>
                <p>Manage and track all hospital patient records across departments.</p>
            </div>
            <button class="btn-action" onclick="window.location.href='addPatient.jsp'">
                <i class="fa-solid fa-plus"></i> Add Patient
            </button>
        </div>

        <div class="table-container">
            <table class="data-table">
                <thead>
                <tr>
                    <th>PATIENT ID</th>
                    <th>NAME</th>
                    <th>AGE</th>
                    <th>GENDER</th>
                    <th>PHONE</th>
                    <th>LAST VISIT</th>
                    <th>ACTIONS</th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${empty patientList}">
                        <tr>
                            <td colspan="7" class="empty-state">
                                No patients found.
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="patient" items="${patientList}">
                            <tr>
                                <td>${patient.id}</td>
                                <td>${patient.name}</td>
                                <td>${patient.age}</td>
                                <td>${patient.gender}</td>
                                <td>${patient.phone}</td>
                                <td>${patient.lastVisit}</td>
                                <td>
                                    <a href="viewPatient.jsp?id=${patient.id}" style="color: var(--primary-teal); margin-right: 10px;"><i class="fa-solid fa-eye"></i></a>
                                    <a href="editPatient.jsp?id=${patient.id}" style="color: var(--primary-blue); margin-right: 10px;"><i class="fa-solid fa-pen"></i></a>
                                    <a href="deletePatient.jsp?id=${patient.id}" style="color: #ef4444;"><i class="fa-solid fa-trash"></i></a>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>

            <div class="pagination-bar">
                <div class="pagination-info">
                    Showing ${not empty patientList ? patientList.size() : 0} patients
                </div>
                <div class="pagination-controls">
                    <button class="page-btn"><i class="fa-solid fa-chevron-left"></i></button>
                    <button class="page-btn active">1</button>
                    <button class="page-btn"><i class="fa-solid fa-chevron-right"></i></button>
                </div>
            </div>
        </div>

    </main>
</div>

</body>
</html>