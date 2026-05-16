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

        /* ===== LAYOUT ===== */
        .main-wrapper {
            flex: 1;
            display: flex;
            flex-direction: column;
            overflow: hidden;
            position: relative;
        }
        .topbar {
            height: 64px;
            background-color: white;
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
            display: flex;
            align-items: center;
            background-color: #f3f4f6; border-radius: 20px;
            padding: 8px 16px; width: 400px;
        }
        .top-search i { color: #9ca3af; margin-right: 8px; font-size: 14px; }
        .top-search input {
            border: none;
            background: transparent; outline: none;
            width: 100%; font-size: 13px; color: var(--text-dark);
        }
        .topbar-right { display: flex; align-items: center; gap: 20px; }
        .top-icon { font-size: 18px; color: var(--text-gray); cursor: pointer; }
        .btn-support {
            background-color: #f0fdf4;
            color: var(--primary-teal);
            border: 1px solid #bbf7d0; border-radius: 20px;
            padding: 6px 16px; font-size: 13px; font-weight: 500;
            cursor: pointer; transition: all 0.2s;
        }

        /* ===== CONTENT ===== */
        .content {
            padding: 32px;
            overflow-y: auto;
            flex: 1; background-color: #fdfdfd;
        }
        .page-header { margin-bottom: 24px; }
        .page-title h2 { font-size: 28px; font-weight: 700; color: #1a202c; margin-bottom: 4px; }
        .page-title p  { font-size: 14px; color: var(--text-gray); }

        /* ===== TOAST ===== */
        .toast {
            display: flex;
            align-items: center; gap: 10px;
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
            background-color: white;
            border: 1px solid var(--border-color);
            border-radius: 12px; box-shadow: 0 1px 3px rgba(0,0,0,0.03); overflow: hidden;
        }
        .data-table { width: 100%; border-collapse: collapse; text-align: left; }
        .data-table th {
            background-color: var(--table-header-bg);
            padding: 16px 24px;
            font-size: 12px; font-weight: 700;
            color: var(--table-header-text); text-transform: uppercase; letter-spacing: 0.5px;
        }
        .data-table td {
            padding: 16px 24px;
            font-size: 14px;
            color: var(--text-dark); border-bottom: 1px solid var(--border-color);
        }
        .action-buttons { display: flex; gap: 8px; align-items: center; }
        .btn-view {
            background: #0d7f6b; color: white; border: none;
            padding: 6px 12px; border-radius: 6px; font-size: 12px; font-weight: 500;
            cursor: pointer; display: flex; align-items: center; gap: 5px;
            text-decoration: none; transition: background 0.2s;
        }
        .btn-delete {
            background: #fee2e2; color: #991b1b; border: none;
            padding: 6px 12px; border-radius: 6px; font-size: 12px; font-weight: 500;
            cursor: pointer; display: flex; align-items: center; gap: 5px;
            text-decoration: none; transition: background 0.2s;
        }

        /* ===== MODAL ===== */
        .modal-overlay {
            position: fixed; inset: 0;
            background: rgba(10, 15, 30, 0.55);
            backdrop-filter: blur(4px);
            display: flex; align-items: center; justify-content: center;
            z-index: 1000; opacity: 0; pointer-events: none;
            transition: opacity 0.25s ease;
        }
        .modal-overlay.active { opacity: 1; pointer-events: all; }
        .modal-card {
            background: white; border-radius: 16px; width: 560px; max-width: 95vw;
            box-shadow: 0 24px 60px rgba(0,0,0,0.18); overflow: hidden;
            transform: translateY(20px) scale(0.97); transition: transform 0.28s cubic-bezier(0.34, 1.56, 0.64, 1);
        }
        .modal-overlay.active .modal-card { transform: translateY(0) scale(1); }
        .modal-header {
            background: linear-gradient(135deg, #0d7f6b 0%, #0a5f51 100%); padding: 24px 28px;
            display: flex; align-items: center; justify-content: space-between;
        }
        .modal-avatar {
            width: 56px; height: 56px; border-radius: 50%;
            background: rgba(255,255,255,0.2); border: 2px solid rgba(255,255,255,0.4);
            display: flex; align-items: center; justify-content: center;
            font-size: 22px; font-weight: 700; color: white; overflow: hidden;
        }
        .modal-body { padding: 24px 28px; }
        .info-section { margin-bottom: 20px; }
        .info-section-title {
            font-size: 10px; font-weight: 700; letter-spacing: 1px;
            text-transform: uppercase; color: var(--primary-teal);
            margin-bottom: 12px; padding-bottom: 6px; border-bottom: 1px solid var(--border-color);
        }
        .info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
        .info-label { font-size: 11px; color: var(--text-gray); font-weight: 500; }
        .info-value { font-size: 14px; color: var(--text-dark); font-weight: 600; }
        .modal-footer {
            padding: 16px 28px; border-top: 1px solid var(--border-color);
            display: flex; justify-content: flex-end; gap: 10px;
        }
    </style>
</head>
<body>

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
                <div class="toast toast-success"><i class="fa-solid fa-circle-check"></i> Patient deleted successfully.</div>
            </c:when>
            <c:when test="${param.error == 'not_found'}">
                <div class="toast toast-error"><i class="fa-solid fa-circle-exclamation"></i> Patient not found.</div>
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
                        <tr><td colspan="7" style="text-align:center; padding:60px;">No patients found.</td></tr>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="patient" items="${patientList}">
                            <c:set var="age" value="${2026 - patient.user.dob.year - 1900}" />
                            <tr>
                                <td>${patient.user.id}</td>
                                <td>${patient.user.name}</td>
                                <td>${age}</td>
                                <td>${patient.user.gender}</td>
                                <td>${patient.user.phone}</td>
                                <td>${patient.bloodGroup}</td>
                                <td>
                                    <div class="action-buttons">
                                        <button class="btn-view" onclick="openModal({
                                                id: '${patient.user.id}',
                                                name: '${patient.user.name}',
                                                gender: '${patient.user.gender}',
                                                dob: '${patient.user.dob}',
                                                phone: '${patient.user.phone}',
                                                email: '${patient.user.email}',
                                                address: '${patient.user.address}',
                                                bloodGroup: '${patient.bloodGroup}',
                                                createdAt: '${patient.user.createdAt}'
                                                })"><i class="fa-solid fa-eye"></i> View</button>
                                        <a href="<%= request.getContextPath() %>/deletePatient?id=${patient.user.id}" class="btn-delete" onclick="return confirm('Are you sure?')"><i class="fa-solid fa-trash"></i> Delete</a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
                </tbody>
            </table>
        </div>
    </main>
</div>

<div class="modal-overlay" id="patientModal" onclick="handleOverlayClick(event)">
    <div class="modal-card">
        <div class="modal-header">
            <div style="display:flex; align-items:center; gap:16px;">
                <div class="modal-avatar" id="modalAvatar">P</div>
                <div style="color:white; font-weight:700;" id="modalName">—</div>
            </div>
            <button style="background:none; border:none; color:white; cursor:pointer;" onclick="closeModal()"><i class="fa-solid fa-xmark"></i></button>
        </div>
        <div class="modal-body">
            <div class="info-section">
                <div class="info-section-title">Personal Information</div>
                <div class="info-grid">
                    <div class="info-item"><div class="info-label">ID</div><div id="modalId" class="info-value"></div></div>
                    <div class="info-item"><div class="info-label">Gender</div><div id="modalGender" class="info-value"></div></div>
                </div>
            </div>
        </div>
        <div class="modal-footer">
            <button onclick="closeModal()">Close</button>
        </div>
    </div>
</div>

<script>
    const modal = document.getElementById('patientModal');
    const ctx = '<%= request.getContextPath() %>';

    function openModal(p) {
        document.getElementById('modalName').textContent = p.name || '—';
        document.getElementById('modalId').textContent = p.id || '—';
        document.getElementById('modalGender').textContent = p.gender || '—';
        modal.classList.add('active');
    }

    function closeModal() { modal.classList.remove('active'); }
    function handleOverlayClick(e) { if (e.target === modal) closeModal(); }
</script>

</body>
</html>