<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.LocalDate" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
  String userName    = (session.getAttribute("userName") != null) ? (String) session.getAttribute("userName") : "Admin";
  String userRole    = (session.getAttribute("userRole") != null) ? (String) session.getAttribute("userRole") : "";
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
  <title>Upachaar - Receptionists</title>
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
      --card-bg-1: #f8fbfb;
      --card-bg-2: #f0fdf4;
      --card-bg-3: #fff5f5;
    }

    * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Inter', sans-serif; }
    body { background-color: var(--bg-light); color: var(--text-dark); display: flex; height: 100vh; overflow: hidden; }

    /* Sidebar */
    .sidebar { width: 250px; background-color: var(--primary-blue); color: white; display: flex; flex-direction: column; justify-content: space-between; flex-shrink: 0; }
    .sidebar-top { padding: 24px 16px; }
    .brand h1 { font-size: 22px; font-weight: 700; margin-bottom: 4px; }
    .brand p { font-size: 12px; color: var(--sidebar-text-muted); margin-bottom: 32px; }
    .nav-menu { list-style: none; }
    .nav-link { display: flex; align-items: center; padding: 12px 16px; color: white; text-decoration: none; font-size: 14px; font-weight: 500; border-radius: 8px; margin-bottom: 4px; }
    .nav-link i { width: 20px; margin-right: 12px; font-size: 16px; text-align: center; }
    .nav-item.active .nav-link { background-color: white; color: var(--primary-blue); }
    .nav-link:hover:not(.active) { background-color: rgba(255, 255, 255, 0.1); }
    .sidebar-bottom { padding: 20px 16px; }
    .user-profile { display: flex; align-items: center; padding-top: 16px; border-top: 1px solid rgba(255, 255, 255, 0.1); }
    .avatar { width: 36px; height: 36px; background-color: white; color: var(--primary-blue); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 14px; margin-right: 12px; }
    .user-info h4 { font-size: 13px; font-weight: 600; }
    .user-info p { font-size: 11px; color: var(--sidebar-text-muted); }

    /* Main Content */
    .main-wrapper { flex: 1; display: flex; flex-direction: column; overflow: hidden; }
    .topbar { height: 64px; background-color: white; border-bottom: 1px solid var(--border-color); display: flex; align-items: center; justify-content: space-between; padding: 0 32px; }
    .topbar-left { display: flex; gap: 12px; font-size: 16px; font-weight: 600; color: var(--primary-teal); }
    .topbar-left .date { font-size: 13px; color: var(--text-gray); font-weight: 400; }
    .topbar-right { display: flex; align-items: center; gap: 20px; }
    .top-icon { color: var(--text-gray); cursor: pointer; }

    /* Content Area */
    .content { padding: 32px; overflow-y: auto; background-color: #fdfdfd; flex: 1; }
    .page-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 24px; }
    .page-title h2 { font-size: 24px; font-weight: 700; color: #1a202c; }
    .page-title p { font-size: 14px; color: var(--text-gray); margin-top: 4px; }

    /* Alert Styles */
    .alert { padding: 12px 16px; border-radius: 8px; margin-bottom: 24px; display: flex; align-items: center; gap: 12px; font-size: 14px; font-weight: 500; animation: fadeIn 0.3s ease; }
    @keyframes fadeIn { from { opacity: 0; transform: translateY(-10px); } to { opacity: 1; transform: translateY(0); } }
    .alert-success { background-color: #ecfdf5; color: #065f46; border: 1px solid #a7f3d0; }
    .alert-error { background-color: #fef2f2; color: #991b1b; border: 1px solid #fecaca; }

    /* Stats Grid */
    .stats-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px; margin-bottom: 24px; }
    .stat-card { background-color: white; border: 1px solid var(--border-color); border-radius: 12px; padding: 24px; display: flex; justify-content: space-between; align-items: flex-start; position: relative; overflow: hidden; }
    .stat-info h3 { font-size: 12px; font-weight: 600; color: var(--text-gray); text-transform: uppercase; margin-bottom: 12px; }
    .stat-info .value { font-size: 28px; font-weight: 700; color: #111827; display: flex; align-items: baseline; gap: 8px; }
    .stat-info .subtext { font-size: 13px; color: var(--text-gray); font-weight: 400; }
    .badge { background-color: #d1fae5; color: #065f46; font-size: 12px; padding: 4px 10px; border-radius: 12px; font-weight: 600; display: inline-block; }
    .stat-icon { font-size: 20px; }
    .stat-card:nth-child(1) .stat-icon { color: #0ea5e9; }
    .stat-card:nth-child(2) .stat-icon { color: #10b981; }
    .stat-card:nth-child(3) .stat-icon { color: #f97316; }

    /* Table */
    .table-container { background-color: white; border: 1px solid var(--border-color); border-radius: 12px; overflow: hidden; }
    .data-table { width: 100%; border-collapse: collapse; text-align: left; }
    .data-table th { background-color: var(--table-header-bg); padding: 16px 24px; font-size: 12px; font-weight: 700; color: var(--table-header-text); text-transform: uppercase; }
    .data-table td { padding: 16px 24px; font-size: 14px; border-bottom: 1px solid var(--border-color); }
    .empty-state { text-align: center; padding: 60px !important; color: var(--text-gray); }

    /* Table Action Buttons */
    .btn-view { background: #0d7f6b; color: white; border: none; padding: 6px 12px; border-radius: 6px; font-size: 12px; cursor: pointer; display: inline-block; transition: opacity 0.2s; }
    .btn-view:hover { opacity: 0.9; }
    .btn-delete { background: #ef4444; color: white; border: none; padding: 6px 12px; border-radius: 6px; font-size: 12px; cursor: pointer; text-decoration: none; display: inline-block; margin-left: 8px; transition: opacity 0.2s; }
    .btn-delete:hover { opacity: 0.9; }

    /* --- Modal Styles --- */
    .modal-overlay { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(17, 24, 39, 0.6); display: flex; justify-content: center; align-items: center; z-index: 1000; opacity: 0; visibility: hidden; transition: all 0.3s ease; }
    .modal-overlay.active { opacity: 1; visibility: visible; }
    .modal-card { background: white; width: 100%; max-width: 500px; border-radius: 12px; box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1); transform: translateY(-20px); transition: transform 0.3s ease; overflow: hidden; }
    .modal-overlay.active .modal-card { transform: translateY(0); }
    .modal-header { padding: 20px 24px; border-bottom: 1px solid var(--border-color); display: flex; justify-content: space-between; align-items: center; background-color: #f8fafc; }
    .modal-header h3 { font-size: 18px; font-weight: 700; color: #111827; }
    .btn-close { background: none; border: none; font-size: 20px; color: var(--text-gray); cursor: pointer; transition: color 0.2s; }
    .btn-close:hover { color: #ef4444; }

    .modal-body { padding: 24px; }
    .modal-profile-header { display: flex; align-items: center; gap: 16px; margin-bottom: 24px; padding-bottom: 20px; border-bottom: 1px solid var(--border-color); }
    .modal-avatar { width: 64px; height: 64px; background-color: var(--table-header-bg); color: var(--primary-teal); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 24px; font-weight: 700; }
    .modal-info h4 { font-size: 18px; font-weight: 700; color: #111827; margin-bottom: 6px; }

    .modal-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
    .modal-item label { display: block; font-size: 12px; color: var(--text-gray); text-transform: uppercase; font-weight: 600; margin-bottom: 4px; }
    .modal-item p { font-size: 14px; color: #111827; font-weight: 500; }
  </style>
</head>
<body>
<aside class="sidebar">
  <div class="sidebar-top">
    <div class="brand"><h1>Upachaar</h1><p>Clinical Oversight</p></div>
    <ul class="nav-menu">
      <li class="nav-item">
        <a href="<%= request.getContextPath() %>/Admin-dashboard" class="nav-link"><i class="fa-solid fa-border-all"></i> Dashboard</a>
      </li>
      <li class="nav-item">
        <a href="<%= request.getContextPath() %>/doctors" class="nav-link"><i class="fa-solid fa-stethoscope"></i> Doctors</a>
      </li>
      <li class="nav-item">
        <a href="<%= request.getContextPath() %>/patients" class="nav-link"><i class="fa-solid fa-users"></i> Patients</a>
      </li>
      <li class="nav-item active">
        <a href="<%= request.getContextPath() %>/receptionists" class="nav-link"><i class="fa-solid fa-user-nurse"></i> Receptionists</a>
      </li>
      <li class="nav-item">
        <a href="<%= request.getContextPath() %>/appointments" class="nav-link"><i class="fa-regular fa-calendar"></i> Appointments</a>
      </li>
      <li class="nav-item">
        <a href="<%= request.getContextPath() %>/billing" class="nav-link"><i class="fa-solid fa-file-invoice-dollar"></i> Billing</a>
      </li>
      <li class="nav-item">
        <a href="<%= request.getContextPath() %>/reviews" class="nav-link">
          <i class="fa-solid fa-star"></i> Reviews
        </a>
      </li>
    </ul>
  </div>
  <div class="sidebar-bottom">
    <div class="user-profile">
      <div class="avatar">${not empty sessionScope.loggedInUser ? sessionScope.loggedInUser.name.substring(0,1) : 'S'}</div>
      <div class="user-info">
        <h4>${not empty sessionScope.loggedInUser ? sessionScope.loggedInUser.name : ''}</h4>
        <p>${not empty sessionScope.loggedInUser ? sessionScope.loggedInUser.role : ''}</p>
      </div>
    </div>
  </div>
</aside>

<div class="main-wrapper">
  <header class="topbar">
    <div class="topbar-left">
      <span class="title">Receptionists</span>
      <span class="divider">|</span>
      <span class="date"><%= currentDate %></span>
    </div>

  </header>

  <main class="content">
    <c:if test="${param.success == 'deleted'}">
      <div class="alert alert-success" id="alertBox">
        <i class="fa-solid fa-circle-check"></i>
        Receptionist has been successfully removed from the system.
      </div>
    </c:if>
    <c:if test="${not empty param.error}">
      <div class="alert alert-error" id="alertBox">
        <i class="fa-solid fa-circle-exclamation"></i>
        <c:choose>
          <c:when test="${param.error == 'not_found'}">Error: Receptionist not found.</c:when>
          <c:when test="${param.error == 'delete_failed'}">Error: Database transaction failed.</c:when>
          <c:otherwise>An unexpected error occurred during deletion.</c:otherwise>
        </c:choose>
      </div>
    </c:if>

    <div class="page-header">
      <div class="page-title">
        <h2>Receptionist Management</h2>
        <p>Overview and management of front-desk staff.</p>
      </div>
    </div>

    <div class="stats-grid">
      <div class="stat-card" style="background: var(--card-bg-1);">
        <div class="stat-info">
          <h3>TOTAL RECEPTIONISTS</h3>
          <div class="value">${not empty totalReceptionists ? totalReceptionists : 0} <span class="subtext">registered</span></div>
        </div>
        <i class="fa-solid fa-user-group stat-icon"></i>
      </div>
      <div class="stat-card" style="background: var(--card-bg-2);">
        <div class="stat-info">
          <h3>ACTIVE</h3>
          <div class="value">${not empty activeReceptionists ? activeReceptionists : 0} <span class="badge" style="margin-left:8px;">Available</span></div>
        </div>
        <i class="fa-solid fa-user-check stat-icon"></i>
      </div>
      <div class="stat-card" style="background: var(--card-bg-3);">
        <div class="stat-info">
          <h3>ON LEAVE</h3>
          <div class="value">${not empty onLeaveReceptionists ? onLeaveReceptionists : 0}</div>
        </div>
        <i class="fa-solid fa-user-minus stat-icon"></i>
      </div>
    </div>

    <div class="table-container">
      <table class="data-table">
        <thead>
        <tr>
          <th>ID</th>
          <th>NAME</th>
          <th>CONTACT</th>
          <th>JOIN DATE</th>
          <th>STATUS</th>
          <th>ACTIONS</th>
        </tr>
        </thead>
        <tbody>
        <c:choose>
          <c:when test="${empty receptionistList}">
            <tr><td colspan="6" class="empty-state">No receptionists found matching this criteria.</td></tr>
          </c:when>
          <c:otherwise>
            <c:forEach var="receptionist" items="${receptionistList}">
              <tr>
                <td>${receptionist.user.id}</td>
                <td>${receptionist.user.name}</td>
                <td>${receptionist.user.phone}</td>
                <td>${receptionist.user.createdAt}</td>
                <td>
                  <c:choose>
                    <c:when test="${receptionist.status == 'Active'}">
                      <span class="badge" style="background-color: #d1fae5; color: #065f46;">Active</span>
                    </c:when>
                    <c:otherwise>
                      <span class="badge" style="background-color: #fce7f3; color: #9d174d;">On Leave</span>
                    </c:otherwise>
                  </c:choose>
                </td>
                <td>
                  <button type="button" class="btn-view"
                          onclick="openModal(this)"
                          data-id="${receptionist.user.id}"
                          data-name="${receptionist.user.name}"
                          data-phone="${receptionist.user.phone}"
                          data-email="${receptionist.user.email}"
                          data-gender="${receptionist.user.gender}"
                          data-dob="${receptionist.user.dob}"
                          data-address="${receptionist.user.address}"
                          data-joined="${receptionist.user.createdAt}"
                          data-status="${receptionist.status}">
                    View
                  </button>

                  <a href="${pageContext.request.contextPath}/deleteReceptionist?id=${receptionist.user.id}" class="btn-delete" onclick="return confirm('Delete this receptionist? This action cannot be undone.');">
                    Delete
                  </a>
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

<div class="modal-overlay" id="viewModal">
  <div class="modal-card">
    <div class="modal-header">
      <h3>Profile Overview</h3>
      <button class="btn-close" onclick="closeModal()"><i class="fa-solid fa-xmark"></i></button>
    </div>

    <div class="modal-body">
      <div class="modal-profile-header">
        <div class="modal-avatar" id="modalAvatar">S</div>
        <div class="modal-info">
          <h4 id="modalName">Name</h4>
          <span class="badge" id="modalStatus">Active</span>
        </div>
      </div>

      <div class="modal-grid">
        <div class="modal-item">
          <label>Receptionist ID</label>
          <p id="modalId">-</p>
        </div>
        <div class="modal-item">
          <label>Phone Number</label>
          <p id="modalPhone">-</p>
        </div>
        <div class="modal-item">
          <label>Email Address</label>
          <p id="modalEmail">-</p>
        </div>
        <div class="modal-item">
          <label>Gender</label>
          <p id="modalGender" style="text-transform: capitalize;">-</p>
        </div>
        <div class="modal-item">
          <label>Date of Birth</label>
          <p id="modalDob">-</p>
        </div>
        <div class="modal-item">
          <label>Join Date</label>
          <p id="modalJoined">-</p>
        </div>
        <div class="modal-item" style="grid-column: span 2;">
          <label>Residential Address</label>
          <p id="modalAddress">-</p>
        </div>
      </div>
    </div>
  </div>
</div>

<script>
  // -- Auto-dismiss Alerts --
  window.onload = function() {
    const alertBox = document.getElementById('alertBox');
    if (alertBox) {
      setTimeout(() => {
        alertBox.style.transition = "opacity 0.5s ease";
        alertBox.style.opacity = "0";
        setTimeout(() => alertBox.remove(), 500);
      }, 4000); // 4 Seconds
    }
  };

  // -- Modal Logic --
  function openModal(button) {
    const name = button.getAttribute('data-name') || 'N/A';
    const status = button.getAttribute('data-status');

    document.getElementById('modalAvatar').innerText = name.charAt(0).toUpperCase();
    document.getElementById('modalName').innerText = name;
    document.getElementById('modalId').innerText = button.getAttribute('data-id') || 'N/A';
    document.getElementById('modalPhone').innerText = button.getAttribute('data-phone') || 'N/A';
    document.getElementById('modalEmail').innerText = button.getAttribute('data-email') || 'N/A';
    document.getElementById('modalGender').innerText = button.getAttribute('data-gender') || 'N/A';
    document.getElementById('modalDob').innerText = button.getAttribute('data-dob') || 'N/A';
    document.getElementById('modalJoined').innerText = button.getAttribute('data-joined') || 'N/A';
    document.getElementById('modalAddress').innerText = button.getAttribute('data-address') || 'N/A';

    const statusBadge = document.getElementById('modalStatus');
    if(status === 'active') {
      statusBadge.innerText = 'Active';
      statusBadge.style.backgroundColor = '#d1fae5';
      statusBadge.style.color = '#065f46';
    } else {
      statusBadge.innerText = 'On Leave';
      statusBadge.style.backgroundColor = '#fce7f3';
      statusBadge.style.color = '#9d174d';
    }

    document.getElementById('viewModal').classList.add('active');
  }

  function closeModal() {
    document.getElementById('viewModal').classList.remove('active');
  }

  window.onclick = function(event) {
    const modal = document.getElementById('viewModal');
    if (event.target === modal) {
      closeModal();
    }
  }
</script>

</body>
</html>
