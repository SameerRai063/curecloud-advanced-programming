<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.List" %>
<%@ page import="Doctor.Model.Doctor" %>
<%
  String userName = (session.getAttribute("userName") != null) ? (String) session.getAttribute("userName") : "Admin";
  String userRole = (session.getAttribute("userRole") != null) ? (String) session.getAttribute("userRole") : "Super Admin";
  String currentDate = LocalDate.now().format(DateTimeFormatter.ofPattern("MMM d, yyyy"));

  int totalDoctors = (request.getAttribute("totalDoctors") != null) ? (Integer) request.getAttribute("totalDoctors") : 0;
  int activeToday  = (request.getAttribute("activeToday")  != null) ? (Integer) request.getAttribute("activeToday")  : 0;
  int onLeave      = (request.getAttribute("onLeave")      != null) ? (Integer) request.getAttribute("onLeave")      : 0;

  List<Doctor> doctorsList = null;
  Object obj = request.getAttribute("doctorsList");
  if (obj != null) {
    doctorsList = (List<Doctor>) obj;
  }

  String errorMessage = (String) request.getAttribute("errorMessage");
  String errorClass   = (String) request.getAttribute("errorClass");

  // Parameters from DeleteDoctorServlet
  String successParam = request.getParameter("success");
  String errorParam = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Upachaar - Manage Doctors</title>
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

    /* --- Sidebar & Topbar Styles (Unchanged) --- */
    .sidebar { width: 250px; background-color: var(--primary-blue); color: white; display: flex; flex-direction: column; justify-content: space-between; flex-shrink: 0; }
    .sidebar-top { padding: 24px 16px; }
    .brand h1 { font-size: 22px; font-weight: 700; letter-spacing: 0.5px; margin-bottom: 4px; }
    .brand p   { font-size: 12px; color: var(--sidebar-text-muted); margin-bottom: 32px; }
    .nav-menu { list-style: none; }
    .nav-item  { margin-bottom: 4px; }
    .nav-link { display: flex; align-items: center; padding: 12px 16px; color: white; text-decoration: none; font-size: 14px; font-weight: 500; border-radius: 8px; transition: all 0.2s; }
    .nav-link i { width: 20px; margin-right: 12px; font-size: 16px; text-align: center; }
    .nav-item.active .nav-link { background-color: white; color: var(--primary-blue); }
    .nav-link:hover:not(.active) { background-color: rgba(255,255,255,0.1); }
    .sidebar-bottom { padding: 20px 16px; }
    .social-links { margin-bottom: 24px; padding: 0 8px; }
    .social-links p { font-size: 11px; color: var(--sidebar-text-muted); margin-bottom: 8px; }
    .social-links i { margin-right: 12px; font-size: 14px; cursor: pointer; color: var(--sidebar-text-muted); }
    .user-profile { display: flex; align-items: center; padding-top: 16px; border-top: 1px solid rgba(255,255,255,0.1); }
    .avatar { width: 36px; height: 36px; background-color: white; color: var(--primary-blue); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 14px; margin-right: 12px; text-transform: uppercase; }
    .user-info h4 { font-size: 13px; font-weight: 600; }
    .user-info p  { font-size: 11px; color: var(--sidebar-text-muted); }

    .main-wrapper { flex: 1; display: flex; flex-direction: column; overflow: hidden; position: relative; }
    .topbar { height: 64px; background-color: white; border-bottom: 1px solid var(--border-color); display: flex; align-items: center; justify-content: space-between; padding: 0 32px; flex-shrink: 0; }
    .topbar-left { display: flex; align-items: center; gap: 12px; }
    .topbar-left .title  { font-size: 16px; font-weight: 600; color: var(--primary-teal); }
    .topbar-left .divider { color: #d1d5db; }
    .topbar-left .date   { font-size: 13px; color: var(--text-gray); }
    .topbar-center { flex: 1; display: flex; justify-content: center; }
    .top-search { display: flex; align-items: center; background-color: #f3f4f6; border-radius: 20px; padding: 8px 16px; width: 400px; }
    .top-search i { color: #9ca3af; margin-right: 8px; font-size: 14px; }
    .top-search input { border: none; background: transparent; outline: none; width: 100%; font-size: 13px; color: var(--text-dark); }
    .top-search input::placeholder { color: #9ca3af; }
    .topbar-right { display: flex; align-items: center; gap: 20px; }
    .top-icon { font-size: 18px; color: var(--text-gray); cursor: pointer; }
    .btn-support { background-color: #f0fdf4; color: var(--primary-teal); border: 1px solid #bbf7d0; border-radius: 20px; padding: 6px 16px; font-size: 13px; font-weight: 500; cursor: pointer; }

    /* --- Content & Stats Styles --- */
    .content { padding: 32px; overflow-y: auto; flex: 1; background-color: #fdfdfd; }
    .page-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 24px; }
    .page-title h2 { font-size: 28px; font-weight: 700; color: #1a202c; margin-bottom: 4px; }
    .page-title p  { font-size: 14px; color: var(--text-gray); }

    /* Alert Banner Styles */
    .alert { padding: 12px 16px; border-radius: 8px; margin-bottom: 24px; display: flex; align-items: center; gap: 12px; font-size: 14px; font-weight: 500; animation: fadeIn 0.3s ease; }
    @keyframes fadeIn { from { opacity: 0; transform: translateY(-10px); } to { opacity: 1; transform: translateY(0); } }
    .alert-success { background-color: #ecfdf5; color: #065f46; border: 1px solid #a7f3d0; }
    .alert-error { background-color: #fef2f2; color: #991b1b; border: 1px solid #fecaca; }
    .error-banner { background: #fee2e2; color: #991b1b; border: 1px solid #fca5a5; border-radius: 8px; padding: 12px 20px; margin-bottom: 20px; font-size: 13px; }

    .stats-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 24px; margin-bottom: 24px; }
    .stat-card { background-color: white; border: 1px solid var(--border-color); border-radius: 12px; padding: 24px; position: relative; overflow: hidden; box-shadow: 0 1px 3px rgba(0,0,0,0.03); height: 120px; display: flex; flex-direction: column; justify-content: center; }
    .stat-title { font-size: 12px; font-weight: 600; color: var(--text-gray); text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 12px; position: relative; z-index: 2; }
    .stat-value-row { display: flex; align-items: baseline; gap: 8px; position: relative; z-index: 2; }
    .stat-num   { font-size: 28px; font-weight: 700; color: #111827; }
    .stat-label { font-size: 13px; color: var(--text-gray); }
    .badge-available { background-color: #d1fae5; color: #065f46; padding: 4px 10px; border-radius: 12px; font-size: 11px; font-weight: 600; }
    .bg-shape { position: absolute; right: -20%; top: -20%; width: 150px; height: 150px; border-radius: 50%; z-index: 1; }
    .shape-blue   { background-color: #f0f4ff; }
    .shape-green  { background-color: #ecfdf5; }
    .shape-orange { background-color: #fff7ed; }

    /* --- Table Styles --- */
    .table-container { background-color: white; border: 1px solid var(--border-color); border-radius: 12px; box-shadow: 0 1px 3px rgba(0,0,0,0.03); overflow: hidden; }
    .data-table { width: 100%; border-collapse: collapse; text-align: left; }
    .data-table th { background-color: var(--table-header-bg); padding: 16px 24px; font-size: 12px; font-weight: 700; color: var(--table-header-text); text-transform: uppercase; letter-spacing: 0.5px; }
    .data-table td { padding: 16px 24px; font-size: 14px; color: var(--text-dark); border-bottom: 1px solid var(--border-color); }
    .empty-state { text-align: center; padding: 60px 20px !important; color: var(--text-gray); font-size: 14px; }

    /* Button Styles */
    .btn-view { background: #0d7f6b; color: white; border: none; padding: 6px 12px; border-radius: 6px; font-size: 12px; cursor: pointer; display: inline-block; transition: opacity 0.2s; }
    .btn-view:hover { opacity: 0.9; }
    .btn-delete { background: #ef4444; color: white; border: none; padding: 6px 12px; border-radius: 6px; font-size: 12px; cursor: pointer; text-decoration: none; display: inline-block; margin-left: 8px; transition: opacity 0.2s; }
    .btn-delete:hover { opacity: 0.9; }

    .pagination-bar { display: flex; justify-content: space-between; align-items: center; padding: 16px 24px; border-top: 1px solid var(--border-color); }
    .pagination-info { font-size: 13px; color: var(--text-gray); }
    .pagination-controls { display: flex; align-items: center; gap: 8px; }
    .page-btn { width: 32px; height: 32px; display: flex; align-items: center; justify-content: center; border: none; background: transparent; border-radius: 4px; color: var(--text-gray); cursor: pointer; font-size: 14px; }
    .page-btn.active { background-color: var(--primary-teal); color: white; }

    /* --- Modal Styles --- */
    .modal-overlay { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(17, 24, 39, 0.6); display: flex; justify-content: center; align-items: center; z-index: 1000; opacity: 0; visibility: hidden; transition: all 0.3s ease; }
    .modal-overlay.active { opacity: 1; visibility: visible; }
    .modal-card { background: white; width: 100%; max-width: 550px; border-radius: 12px; box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1); transform: translateY(-20px); transition: transform 0.3s ease; overflow: hidden; }
    .modal-overlay.active .modal-card { transform: translateY(0); }
    .modal-header { padding: 20px 24px; border-bottom: 1px solid var(--border-color); display: flex; justify-content: space-between; align-items: center; background-color: #f8fafc; }
    .modal-header h3 { font-size: 18px; font-weight: 700; color: #111827; }
    .btn-close { background: none; border: none; font-size: 20px; color: var(--text-gray); cursor: pointer; transition: color 0.2s; }
    .btn-close:hover { color: #ef4444; }

    .modal-body { padding: 24px; }
    .modal-profile-header { display: flex; align-items: center; gap: 16px; margin-bottom: 24px; padding-bottom: 20px; border-bottom: 1px solid var(--border-color); }
    .modal-avatar { width: 64px; height: 64px; background-color: var(--table-header-bg); color: var(--primary-teal); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 24px; font-weight: 700; text-transform: uppercase;}
    .modal-info h4 { font-size: 18px; font-weight: 700; color: #111827; margin-bottom: 4px; }
    .modal-info p { font-size: 13px; color: var(--text-gray); margin-bottom: 8px;}

    .modal-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
    .modal-item label { display: block; font-size: 12px; color: var(--text-gray); text-transform: uppercase; font-weight: 600; margin-bottom: 4px; }
    .modal-item p { font-size: 14px; color: #111827; font-weight: 500; }
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
        <a href="<%= request.getContextPath() %>/Admin-dashboard" class="nav-link">
          <i class="fa-solid fa-border-all"></i> Dashboard
        </a>
      </li>
      <li class="nav-item active">
        <a href="<%= request.getContextPath() %>/doctors" class="nav-link">
          <i class="fa-solid fa-stethoscope"></i> Doctors
        </a>
      </li>
      <li class="nav-item">
        <a href="<%= request.getContextPath() %>/patients" class="nav-link">
          <i class="fa-solid fa-users"></i> Patients
        </a>
      </li>
      <li class="nav-item">
        <a href="<%= request.getContextPath() %>/receptionists" class="nav-link">
          <i class="fa-solid fa-user-nurse"></i> Receptionists
        </a>
      </li>
      <li class="nav-item">
        <a href="<%= request.getContextPath() %>/appointments" class="nav-link">
          <i class="fa-regular fa-calendar"></i> Appointments
        </a>
      </li>
      <li class="nav-item">
        <a href="<%= request.getContextPath() %>/billing" class="nav-link">
          <i class="fa-solid fa-file-invoice-dollar"></i> Billing
        </a>
      </li>
      <li class="nav-item">
        <a href="<%= request.getContextPath() %>/reviews" class="nav-link">
          <i class="fa-solid fa-star"></i> Reviews
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
      <div class="avatar"><%= userName.substring(0, 1).toUpperCase() %></div>
      <div class="user-info">
        <h4><%= userName %></h4>
        <p><%= userRole %></p>
      </div>
    </div>
  </div>
</aside>

<div class="main-wrapper">

  <header class="topbar">
    <div class="topbar-left">
      <span class="title">Doctors</span>
      <span class="divider">|</span>
      <span class="date"><%= currentDate %></span>
    </div>
    <div class="topbar-center">
      <div class="top-search">
        <i class="fa-solid fa-magnifying-glass"></i>
        <input type="text" placeholder="Search patients, records, or doctors...">
      </div>
    </div>
    <div class="topbar-right">
      <i class="fa-regular fa-bell top-icon"></i>
      <i class="fa-regular fa-circle-question top-icon"></i>
      <button class="btn-support">Support</button>
    </div>
  </header>

  <main class="content">

    <% if (errorMessage != null) { %>
    <div class="error-banner">
      <strong>Database Error:</strong> [<%= errorClass %>] <%= errorMessage %>
    </div>
    <% } %>

    <% if ("deleted".equals(successParam)) { %>
    <div class="alert alert-success" id="alertBox">
      <i class="fa-solid fa-circle-check"></i>
      Doctor has been successfully removed from the system.
    </div>
    <% } else if (errorParam != null) { %>
    <div class="alert alert-error" id="alertBox">
      <i class="fa-solid fa-circle-exclamation"></i>
      <% if ("not_found".equals(errorParam)) { %>
      Error: Doctor not found in the database.
      <% } else if ("delete_failed".equals(errorParam)) { %>
      Error: Could not delete doctor. Ensure no active appointments exist.
      <% } else { %>
      An unexpected error occurred.
      <% } %>
    </div>
    <% } %>

    <div class="page-header">
      <div class="page-title">
        <h2>Manage Doctors</h2>
        <p>Overview and management of your medical staff.</p>
      </div>
    </div>

    <div class="stats-grid">
      <div class="stat-card">
        <div class="stat-title">TOTAL DOCTORS</div>
        <div class="stat-value-row">
          <span class="stat-num"><%= totalDoctors %></span>
          <span class="stat-label">registered</span>
        </div>
        <div class="bg-shape shape-blue"></div>
      </div>

      <div class="stat-card">
        <div class="stat-title">ACTIVE TODAY</div>
        <div class="stat-value-row">
          <span class="stat-num"><%= activeToday %></span>
          <span class="badge-available">Available</span>
        </div>
        <div class="bg-shape shape-green"></div>
      </div>

      <div class="stat-card">
        <div class="stat-title">ON LEAVE</div>
        <div class="stat-value-row">
          <span class="stat-num"><%= onLeave %></span>
          <i class="fa-regular fa-calendar-days"></i>
        </div>
        <div class="bg-shape shape-orange"></div>
      </div>
    </div>

    <div class="table-container">
      <table class="data-table">
        <thead>
        <tr>
          <th>DOCTOR ID</th>
          <th>NAME</th>
          <th>SPECIALTY</th>
          <th>EXPERIENCE</th>
          <th>STATUS</th>
          <th>ACTIONS</th>
        </tr>
        </thead>
        <tbody>
        <%
          if (doctorsList == null || doctorsList.isEmpty()) {
        %>
        <tr>
          <td colspan="6" class="empty-state">No doctors found.</td>
        </tr>
        <%
        } else {
          for (Doctor doc : doctorsList) {
        %>
        <tr>
          <td><%= doc.getUserId() %></td>
          <td><%= doc.getUser() != null ? doc.getUser().getName() : "—" %></td>
          <td><%= doc.getDepartment() != null ? doc.getDepartment() : "—" %></td>
          <td><%= doc.getExperienceYears() %> yrs</td>
          <td>
            <%
              String status = doc.getStatus();
              if ("active".equalsIgnoreCase(status)) {
            %>
            <span style="background:#d1fae5;color:#065f46;padding:4px 10px;border-radius:12px;font-size:12px;font-weight:600;">Active</span>
            <%
            } else if ("on leave".equalsIgnoreCase(status)) {
            %>
            <span style="background:#fee2e2;color:#991b1b;padding:4px 10px;border-radius:12px;font-size:12px;font-weight:600;">On Leave</span>
            <%
            } else {
            %>
            <span style="background:#e5e7eb;color:#374151;padding:4px 10px;border-radius:12px;font-size:12px;font-weight:600;">Unknown</span>
            <%
              }
            %>
          </td>
          <td>
            <button type="button" class="btn-view"
                    onclick="openModal(this)"
                    data-id="<%= doc.getUserId() %>"
                    data-name="<%= doc.getUser() != null ? doc.getUser().getName() : "—" %>"
                    data-department="<%= doc.getDepartment() != null ? doc.getDepartment() : "—" %>"
                    data-experience="<%= doc.getExperienceYears() %>"
                    data-status="<%= doc.getStatus() != null ? doc.getStatus() : "—" %>"
                    data-qualifications="<%= doc.getQualifications() != null ? doc.getQualifications() : "—" %>"
                    data-phone="<%= doc.getUser() != null ? doc.getUser().getPhone() : "—" %>"
                    data-email="<%= doc.getUser() != null ? doc.getUser().getEmail() : "—" %>"
                    data-gender="<%= doc.getUser() != null ? doc.getUser().getGender() : "—" %>">
              View
            </button>

            <a href="deleteDoctor?id=<%= doc.getUserId() %>" class="btn-delete" onclick="return confirm('Are you sure you want to delete this doctor? This action cannot be undone.');">
              Delete
            </a>
          </td>
        </tr>
        <%
            }
          }
        %>
        </tbody>
      </table>

      <div class="pagination-bar">
        <div class="pagination-info">
          Showing <%= (totalDoctors > 0) ? "1" : "0" %>–<%= Math.min(10, totalDoctors) %> of <%= totalDoctors %> doctors
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

<div class="modal-overlay" id="viewModal">
  <div class="modal-card">
    <div class="modal-header">
      <h3>Doctor Profile</h3>
      <button class="btn-close" onclick="closeModal()"><i class="fa-solid fa-xmark"></i></button>
    </div>

    <div class="modal-body">
      <div class="modal-profile-header">
        <div class="modal-avatar" id="modalAvatar">D</div>
        <div class="modal-info">
          <h4 id="modalName">Name</h4>
          <p id="modalDepartment">Department</p>
          <span class="badge-available" id="modalStatus" style="display: inline-block;">Active</span>
        </div>
      </div>

      <div class="modal-grid">
        <div class="modal-item">
          <label>Doctor ID</label>
          <p id="modalId">-</p>
        </div>
        <div class="modal-item">
          <label>Experience</label>
          <p id="modalExperience">-</p>
        </div>
        <div class="modal-item" style="grid-column: span 2;">
          <label>Qualifications</label>
          <p id="modalQualifications">-</p>
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
      </div>
    </div>
  </div>
</div>

<script>
  // Auto-dismiss Alert Boxes
  window.onload = function() {
    const alertBox = document.getElementById('alertBox');
    if (alertBox) {
      setTimeout(() => {
        alertBox.style.transition = "opacity 0.5s ease";
        alertBox.style.opacity = "0";
        setTimeout(() => alertBox.remove(), 500);
      }, 4000); // Dissappear after 4 seconds
    }
  };

  // Modal Open Logic
  function openModal(button) {
    const name = button.getAttribute('data-name') || 'N/A';
    const status = button.getAttribute('data-status') || '';

    // Populate Data
    document.getElementById('modalAvatar').innerText = name.charAt(0);
    document.getElementById('modalName').innerText = name;
    document.getElementById('modalId').innerText = button.getAttribute('data-id') || 'N/A';
    document.getElementById('modalDepartment').innerText = button.getAttribute('data-department') || 'N/A';
    document.getElementById('modalExperience').innerText = (button.getAttribute('data-experience') || '0') + ' Years';
    document.getElementById('modalQualifications').innerText = button.getAttribute('data-qualifications') || 'N/A';
    document.getElementById('modalPhone').innerText = button.getAttribute('data-phone') || 'N/A';
    document.getElementById('modalEmail').innerText = button.getAttribute('data-email') || 'N/A';
    document.getElementById('modalGender').innerText = button.getAttribute('data-gender') || 'N/A';

    // Handle Status Badge Styling
    const statusBadge = document.getElementById('modalStatus');
    if(status.toLowerCase() === 'active') {
      statusBadge.innerText = 'Active';
      statusBadge.style.backgroundColor = '#d1fae5';
      statusBadge.style.color = '#065f46';
    } else if (status.toLowerCase() === 'on leave') {
      statusBadge.innerText = 'On Leave';
      statusBadge.style.backgroundColor = '#fee2e2';
      statusBadge.style.color = '#991b1b';
    } else {
      statusBadge.innerText = status;
      statusBadge.style.backgroundColor = '#e5e7eb';
      statusBadge.style.color = '#374151';
    }

    // Show Modal
    document.getElementById('viewModal').classList.add('active');
  }

  // Modal Close Logic
  function closeModal() {
    document.getElementById('viewModal').classList.remove('active');
  }

  // Close when clicking outside the modal content
  window.onclick = function(event) {
    const modal = document.getElementById('viewModal');
    if (event.target === modal) {
      closeModal();
    }
  }
</script>

</body>
</html>