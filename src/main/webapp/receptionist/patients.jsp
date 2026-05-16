<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    String userName    = (session.getAttribute("userName") != null) ? (String) session.getAttribute("userName") : "Admin";
    String userRole    = (session.getAttribute("userRole") != null) ? (String) session.getAttribute("userRole") : "Super Admin";
    String currentDate = LocalDate.now().format(DateTimeFormatter.ofPattern("MMM d, yyyy"));

    int    totalDoctors       = (request.getAttribute("totalDoctors")       != null) ? (Integer) request.getAttribute("totalDoctors")       : 0;
    int    totalPatients      = (request.getAttribute("totalPatients")      != null) ? (Integer) request.getAttribute("totalPatients")      : 0;
    int    totalReceptionists = (request.getAttribute("totalReceptionists") != null) ? (Integer) request.getAttribute("totalReceptionists") : 0;
    double totalRevenue       = (request.getAttribute("totalRevenue")       != null) ? (Double)  request.getAttribute("totalRevenue")       : 0.0;

    String errorMessage = (String) request.getAttribute("errorMessage");
%>
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

        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Inter', sans-serif; }

        body {
            background-color: var(--bg-light);
            color: var(--text-dark);
            display: flex;
            height: 100vh;
            overflow: hidden;
        }

        /* ===== SIDEBAR ===== */
        .sidebar {
            width: 250px;
            background-color: var(--primary-blue);
            color: white;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            flex-shrink: 0;
        }
        .sidebar-top { padding: 24px 16px; }
        .brand h1 { font-size: 22px; font-weight: 700; letter-spacing: 0.5px; margin-bottom: 4px; }
        .brand p   { font-size: 12px; color: var(--sidebar-text-muted); margin-bottom: 32px; }
        .nav-menu { list-style: none; }
        .nav-item  { margin-bottom: 4px; }
        .nav-link {
            display: flex; align-items: center;
            padding: 12px 16px; color: white;
            text-decoration: none; font-size: 14px; font-weight: 500;
            border-radius: 8px; transition: all 0.2s;
        }
        .nav-link i { width: 20px; margin-right: 12px; font-size: 16px; text-align: center; }
        .nav-item.active .nav-link { background-color: white; color: var(--primary-blue); }
        .nav-link:hover:not(.active) { background-color: rgba(255,255,255,0.1); }
        .sidebar-bottom { padding: 20px 16px; }
        .social-links { margin-bottom: 24px; padding: 0 8px; }
        .social-links p { font-size: 11px; color: var(--sidebar-text-muted); margin-bottom: 8px; }
        .social-links i { margin-right: 12px; font-size: 14px; cursor: pointer; color: var(--sidebar-text-muted); }
        .user-profile {
            display: flex; align-items: center;
            padding-top: 16px; border-top: 1px solid rgba(255,255,255,0.1);
        }
        .avatar {
            width: 36px; height: 36px;
            background-color: white; color: var(--primary-blue);
            border-radius: 50%; display: flex; align-items: center; justify-content: center;
            font-weight: 700; font-size: 14px; margin-right: 12px;
        }
        .user-info h4 { font-size: 13px; font-weight: 600; }
        .user-info p  { font-size: 11px; color: var(--sidebar-text-muted); }

        /* ===== LAYOUT ===== */
        .main-wrapper {
            flex: 1; display: flex; flex-direction: column;
            overflow: hidden; position: relative;
        }
        .topbar {
            height: 64px; background-color: white;
            border-bottom: 1px solid var(--border-color);
            display: flex; align-items: center; justify-content: space-between;
            padding: 0 32px; flex-shrink: 0;
        }
        .topbar-left { display: flex; align-items: center; gap: 12px; }
        .topbar-left .title   { font-size: 16px; font-weight: 600; color: var(--primary-teal); }
        .topbar-left .divider { color: #d1d5db; }
        .topbar-left .date    { font-size: 13px; color: var(--text-gray); }
        .topbar-center { flex: 1; display: flex; justify-content: center; }
        .top-search {
            display: flex; align-items: center;
            background-color: #f3f4f6; border-radius: 20px;
            padding: 8px 16px; width: 400px;
        }
        .top-search i { color: #9ca3af; margin-right: 8px; font-size: 14px; }
        .top-search input {
            border: none; background: transparent; outline: none;
            width: 100%; font-size: 13px; color: var(--text-dark);
        }
        .top-search input::placeholder { color: #9ca3af; }
        .topbar-right { display: flex; align-items: center; gap: 20px; }
        .top-icon { font-size: 18px; color: var(--text-gray); cursor: pointer; }
        .btn-support {
            background-color: #f0fdf4; color: var(--primary-teal);
            border: 1px solid #bbf7d0; border-radius: 20px;
            padding: 6px 16px; font-size: 13px; font-weight: 500;
            cursor: pointer; transition: all 0.2s;
        }
        .btn-support:hover { background-color: #dcfce7; }

        /* ===== CONTENT ===== */
        .content {
            padding: 32px; overflow-y: auto;
            flex: 1; background-color: #fdfdfd;
        }
        .page-header { margin-bottom: 24px; }
        .page-title h2 { font-size: 28px; font-weight: 700; color: #1a202c; margin-bottom: 4px; }
        .page-title p  { font-size: 14px; color: var(--text-gray); }

        /* ===== TOAST ===== */
        .toast {
            display: flex; align-items: center; gap: 10px;
            padding: 12px 18px; border-radius: 8px;
            font-size: 13px; font-weight: 500; margin-bottom: 20px;
            animation: fadeOut 0.5s ease 3.5s forwards;
        }
        .toast-success { background-color: #d1fae5; color: #065f46; border: 1px solid #6ee7b7; }
        .toast-error   { background-color: #fee2e2; color: #991b1b; border: 1px solid #fca5a5; }
        @keyframes fadeOut {
            to { opacity: 0; height: 0; padding: 0; margin: 0; overflow: hidden; }
        }

        /* ===== TABLE ===== */
        .table-container {
            background-color: white; border: 1px solid var(--border-color);
            border-radius: 12px; box-shadow: 0 1px 3px rgba(0,0,0,0.03); overflow: hidden;
        }
        .data-table { width: 100%; border-collapse: collapse; text-align: left; }
        .data-table th {
            background-color: var(--table-header-bg); padding: 16px 24px;
            font-size: 12px; font-weight: 700;
            color: var(--table-header-text); text-transform: uppercase; letter-spacing: 0.5px;
        }
        .data-table td {
            padding: 16px 24px; font-size: 14px;
            color: var(--text-dark); border-bottom: 1px solid var(--border-color);
        }
        .empty-state { text-align: center; padding: 60px 20px !important; color: var(--text-gray); font-size: 14px; }
        .action-buttons { display: flex; gap: 8px; align-items: center; }
        .btn-view {
            background: #0d7f6b; color: white; border: none;
            padding: 6px 12px; border-radius: 6px; font-size: 12px; font-weight: 500;
            cursor: pointer; display: flex; align-items: center; gap: 5px;
            text-decoration: none; transition: background 0.2s;
        }
        .btn-view:hover { background: #0a6657; }
        .btn-delete {
            background: #fee2e2; color: #991b1b; border: none;
            padding: 6px 12px; border-radius: 6px; font-size: 12px; font-weight: 500;
            cursor: pointer; display: flex; align-items: center; gap: 5px;
            text-decoration: none; transition: background 0.2s;
        }
        .btn-delete:hover { background: #fecaca; }
        .pagination-bar {
            display: flex; justify-content: space-between; align-items: center;
            padding: 16px 24px; border-top: 1px solid var(--border-color);
        }
        .pagination-info { font-size: 13px; color: var(--text-gray); }
        .pagination-controls { display: flex; align-items: center; gap: 8px; }
        .page-btn {
            width: 32px; height: 32px; display: flex; align-items: center; justify-content: center;
            border: none; background: transparent; border-radius: 4px;
            color: var(--text-gray); cursor: pointer; font-size: 14px;
        }
        .page-btn.active { background-color: var(--primary-teal); color: white; }

        /* ===== MODAL OVERLAY ===== */
        .modal-overlay {
            position: fixed; inset: 0;
            background: rgba(10, 15, 30, 0.55);
            backdrop-filter: blur(4px);
            display: flex; align-items: center; justify-content: center;
            z-index: 1000;
            opacity: 0; pointer-events: none;
            transition: opacity 0.25s ease;
        }
        .modal-overlay.active {
            opacity: 1; pointer-events: all;
        }

        /* ===== MODAL CARD ===== */
        .modal-card {
            background: white;
            border-radius: 16px;
            width: 560px;
            max-width: 95vw;
            box-shadow: 0 24px 60px rgba(0,0,0,0.18);
            overflow: hidden;
            transform: translateY(20px) scale(0.97);
            transition: transform 0.28s cubic-bezier(0.34, 1.56, 0.64, 1);
        }
        .modal-overlay.active .modal-card {
            transform: translateY(0) scale(1);
        }

        /* Modal header strip */
        .modal-header {
            background: linear-gradient(135deg, #0d7f6b 0%, #0a5f51 100%);
            padding: 24px 28px;
            display: flex; align-items: center; justify-content: space-between;
        }
        .modal-header-left { display: flex; align-items: center; gap: 16px; }
        .modal-avatar {
            width: 56px; height: 56px; border-radius: 50%;
            background: rgba(255,255,255,0.2);
            border: 2px solid rgba(255,255,255,0.4);
            display: flex; align-items: center; justify-content: center;
            font-size: 22px; font-weight: 700; color: white;
            overflow: hidden;
        }
        .modal-avatar img { width: 100%; height: 100%; object-fit: cover; }
        .modal-name { font-size: 18px; font-weight: 700; color: white; }
        .modal-role {
            font-size: 12px; color: rgba(255,255,255,0.7);
            margin-top: 2px; display: flex; align-items: center; gap: 6px;
        }
        .status-dot {
            width: 7px; height: 7px; border-radius: 50%;
            display: inline-block;
        }
        .status-active   { background: #6ee7b7; }
        .status-inactive { background: #fca5a5; }
        .modal-close {
            background: rgba(255,255,255,0.15);
            border: none; color: white;
            width: 34px; height: 34px; border-radius: 50%;
            cursor: pointer; font-size: 16px;
            display: flex; align-items: center; justify-content: center;
            transition: background 0.2s;
        }
        .modal-close:hover { background: rgba(255,255,255,0.3); }

        /* Modal body */
        .modal-body { padding: 24px 28px; }

        .info-section { margin-bottom: 20px; }
        .info-section-title {
            font-size: 10px; font-weight: 700; letter-spacing: 1px;
            text-transform: uppercase; color: var(--primary-teal);
            margin-bottom: 12px; padding-bottom: 6px;
            border-bottom: 1px solid var(--border-color);
        }
        .info-grid {
            display: grid; grid-template-columns: 1fr 1fr; gap: 12px;
        }
        .info-item {}
        .info-label { font-size: 11px; color: var(--text-gray); font-weight: 500; margin-bottom: 2px; }
        .info-value { font-size: 14px; color: var(--text-dark); font-weight: 600; }
        .info-value.full { grid-column: 1 / -1; }

        /* Blood group badge */
        .blood-badge {
            display: inline-flex; align-items: center; gap: 4px;
            background: #fee2e2; color: #b91c1c;
            border-radius: 20px; padding: 3px 10px;
            font-size: 13px; font-weight: 700;
        }

        /* Status badge */
        .status-badge {
            display: inline-flex; align-items: center; gap: 5px;
            border-radius: 20px; padding: 3px 10px;
            font-size: 12px; font-weight: 600;
        }
        .status-badge.active   { background: #d1fae5; color: #065f46; }
        .status-badge.inactive { background: #fee2e2; color: #991b1b; }

        /* Modal footer */
        .modal-footer {
            padding: 16px 28px;
            border-top: 1px solid var(--border-color);
            display: flex; justify-content: flex-end; gap: 10px;
        }
        .btn-modal-close {
            padding: 8px 20px; border-radius: 8px;
            font-size: 13px; font-weight: 500;
            border: 1px solid var(--border-color);
            background: white; color: var(--text-gray);
            cursor: pointer; transition: all 0.2s;
        }
        .btn-modal-close:hover { background: #f9fafb; }
        .btn-modal-delete {
            padding: 8px 20px; border-radius: 8px;
            font-size: 13px; font-weight: 500;
            border: none; background: #fee2e2; color: #991b1b;
            cursor: pointer; transition: all 0.2s;
            display: flex; align-items: center; gap: 6px;
        }
        .btn-modal-delete:hover { background: #fecaca; }
    </style>
</head>
<body>

<!-- ===== SIDEBAR ===== -->
<aside class="sidebar">
    <div class="sidebar-top">
        <div class="brand">
            <h1>Upachaar</h1>
            <p>Clinical Oversight</p>
        </div>
        <ul class="nav-menu">
            <li class="nav-item">
                <a href="<%= request.getContextPath() %>/Admin-dashboard" class="nav-link">
                    <i class="fa-solid fa-border-all"></i> Dashboard
                </a>
            </li>
            <li class="nav-item">
                <a href="<%= request.getContextPath() %>/doctors" class="nav-link">
                    <i class="fa-solid fa-stethoscope"></i> Doctors
                </a>
            </li>
            <li class="nav-item active">
                <a href="<%= request.getContextPath() %>/patients" class="nav-link">
                    <i class="fa-solid fa-users"></i> Patients
                </a>
            </li>
            <li class="nav-item">
                <a href="<%= request.getContextPath() %>/appointments" class="nav-link">
                    <i class="fa-regular fa-calendar"></i> Appointments
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

<!-- ===== MAIN ===== -->
<div class="main-wrapper">
    <header class="topbar">
        <div class="topbar-left">
            <span class="title">Patients</span>
            <span class="divider">|</span>
            <span class="date"><%= currentDate %></span>
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

        <%-- Toast notifications --%>
        <c:choose>
            <c:when test="${param.success == 'deleted'}">
                <div class="toast toast-success">
                    <i class="fa-solid fa-circle-check"></i> Patient deleted successfully.
                </div>
            </c:when>
            <c:when test="${param.error == 'not_found'}">
                <div class="toast toast-error">
                    <i class="fa-solid fa-circle-exclamation"></i> Patient not found. It may have already been deleted.
                </div>
            </c:when>
            <c:when test="${param.error == 'delete_failed'}">
                <div class="toast toast-error">
                    <i class="fa-solid fa-circle-exclamation"></i> Deletion failed due to a server error. Please try again.
                </div>
            </c:when>
            <c:when test="${param.error == 'invalid_id' or param.error == 'missing_id'}">
                <div class="toast toast-error">
                    <i class="fa-solid fa-circle-exclamation"></i> Invalid request. Patient ID is missing or malformed.
                </div>
            </c:when>
        </c:choose>

        <div class="page-header">
            <div class="page-title">
                <h2>Patient Management</h2>
                <p>Manage and track all hospital patient records across departments.</p>
            </div>
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
                    <th>BLOOD GROUP</th>
                    <th>ACTIONS</th>
                </tr>
                </thead>
                <tbody>
                <c:choose>
                    <c:when test="${empty patientList}">
                        <tr>
                            <td colspan="7" class="empty-state">No patients found.</td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="patient" items="${patientList}">
                            <%-- Compute age --%>
                            <c:set var="age" value="--" />
                            <c:if test="${not empty patient.user.dob}">
                                <c:set var="age" value="${2026 - patient.user.dob.year - 1900}" />
                            </c:if>
                            <tr>
                                <td>${patient.user.id}</td>
                                <td>${patient.user.name}</td>
                                <td>${age}</td>
                                <td>${patient.user.gender}</td>
                                <td>${patient.user.phone}</td>
                                <td>${patient.bloodGroup}</td>
                                <td>
                                    <div class="action-buttons">
                                            <%-- View button: all data in data-* attributes --%>
                                        <button class="btn-view"
                                                onclick="openModal({
                                                        id:           '${patient.user.id}',
                                                        name:         '${patient.user.name}',
                                                        gender:       '${patient.user.gender}',
                                                        age:          '${age}',
                                                        dob:          '${patient.user.dob}',
                                                        phone:        '${patient.user.phone}',
                                                        email:        '${patient.user.email}',
                                                        address:      '${patient.user.address}',
                                                        bloodGroup:   '${patient.bloodGroup}',
                                                        isActive:     '${patient.active}',
                                                        profileImage: '${patient.user.profileImage}',
                                                        createdAt:    '${patient.user.createdAt}'
                                                        })">
                                            <i class="fa-solid fa-eye"></i> View
                                        </button>
                                        <a href="<%= request.getContextPath() %>/deletePatient?id=${patient.user.id}"
                                           class="btn-delete"
                                           onclick="return confirm('Are you sure you want to delete this patient?')">
                                            <i class="fa-solid fa-trash"></i> Delete
                                        </a>
                                    </div>
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

<!-- ===== PATIENT VIEW MODAL ===== -->
<!-- ===== PATIENT VIEW MODAL ===== -->
<div class="modal-overlay" id="patientModal" onclick="handleOverlayClick(event)">
    <div class="modal-card">

        <div class="modal-header">
            <div class="modal-header-left">
                <div class="modal-avatar" id="modalAvatar">P</div>
                <div>
                    <div class="modal-name" id="modalName">—</div>
                </div>
            </div>

            <button class="modal-close" onclick="closeModal()">
                <i class="fa-solid fa-xmark"></i>
            </button>
        </div>

        <div class="modal-body">

            <div class="info-section">
                <div class="info-section-title">Personal Information</div>

                <div class="info-grid">
                    <div class="info-item">
                        <div class="info-label">Patient ID</div>
                        <div class="info-value" id="modalId">—</div>
                    </div>

                    <div class="info-item">
                        <div class="info-label">Gender</div>
                        <div class="info-value" id="modalGender">—</div>
                    </div>

                    <div class="info-item">
                        <div class="info-label">Date of Birth</div>
                        <div class="info-value" id="modalDob">—</div>
                    </div>

                    <div class="info-item" style="grid-column: 1 / -1;">
                        <div class="info-label">Address</div>
                        <div class="info-value" id="modalAddress">—</div>
                    </div>
                </div>
            </div>

            <div class="info-section">
                <div class="info-section-title">Contact Details</div>

                <div class="info-grid">
                    <div class="info-item">
                        <div class="info-label">Phone</div>
                        <div class="info-value" id="modalPhone">—</div>
                    </div>

                    <div class="info-item">
                        <div class="info-label">Email</div>
                        <div class="info-value" id="modalEmail">—</div>
                    </div>
                </div>
            </div>

            <div class="info-section">
                <div class="info-section-title">Medical Information</div>

                <div class="info-grid">
                    <div class="info-item">
                        <div class="info-label">Blood Group</div>
                        <div class="info-value" id="modalBloodGroup">—</div>
                    </div>

                    <div class="info-item">
                        <div class="info-label">Registered On</div>
                        <div class="info-value" id="modalCreatedAt">—</div>
                    </div>
                </div>
            </div>

        </div>

        <div class="modal-footer">
            <button class="btn-modal-close" onclick="closeModal()">
                Close
            </button>

            <button class="btn-modal-delete" id="modalDeleteBtn">
                <i class="fa-solid fa-trash"></i> Delete Patient
            </button>
        </div>

    </div>
</div>

<script>
    const modal = document.getElementById('patientModal');
    const ctx = '<%= request.getContextPath() %>';

    function openModal(p) {

        // Avatar
        const initial = p.name ? p.name.charAt(0).toUpperCase() : 'P';
        const avatarEl = document.getElementById('modalAvatar');

        if (p.profileImage && p.profileImage !== 'null' && p.profileImage.trim() !== '') {
            avatarEl.innerHTML =
                `<img src="${ctx}/uploads/${p.profileImage}" alt="Profile">`;
        } else {
            avatarEl.textContent = initial;
        }

        // Header
        document.getElementById('modalName').textContent =
            p.name || '—';

        // Personal Information
        document.getElementById('modalId').textContent =
            p.id || '—';

        document.getElementById('modalGender').textContent =
            p.gender || '—';

        document.getElementById('modalDob').textContent =
            formatDate(p.dob);

        document.getElementById('modalAddress').textContent =
            p.address || '—';

        // Contact Details
        document.getElementById('modalPhone').textContent =
            p.phone || '—';

        document.getElementById('modalEmail').textContent =
            p.email || '—';

        // Medical Information
        document.getElementById('modalBloodGroup').textContent =
            p.bloodGroup || '—';

        document.getElementById('modalCreatedAt').textContent =
            formatDate(p.createdAt);

        // Delete Button
        document.getElementById('modalDeleteBtn').onclick = function () {
            if (confirm('Are you sure you want to delete this patient?')) {
                window.location.href =
                    ctx + '/deletePatient?id=' + p.id;
            }
        };

        // Show Modal
        modal.classList.add('active');
        document.body.style.overflow = 'hidden';
    }

    function closeModal() {
        modal.classList.remove('active');
        document.body.style.overflow = '';
    }

    function handleOverlayClick(e) {
        if (e.target === modal) {
            closeModal();
        }
    }

    function formatDate(val) {
        if (!val || val === 'null' || val.trim() === '') {
            return '—';
        }

        try {
            const d = new Date(val);

            if (isNaN(d.getTime())) {
                return val;
            }

            return d.toLocaleDateString('en-US', {
                year: 'numeric',
                month: 'long',
                day: 'numeric'
            });

        } catch (e) {
            return val;
        }
    }

    document.addEventListener('keydown', function (e) {
        if (e.key === 'Escape') {
            closeModal();
        }
    });
</script>

</body>
</html>
