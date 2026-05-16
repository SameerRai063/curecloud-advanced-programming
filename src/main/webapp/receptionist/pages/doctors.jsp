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

<%--
  JSP FRAGMENT: Injected directly into index.jsp.
  No <html>, <head>, or <body> tags.
--%>

<style>
  /* Scoped CSS for Doctors Fragment */
  .content { padding: 32px; overflow-y: auto; flex: 1; background-color: #fdfdfd; }
  .page-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 24px; }
  .page-title h2 { font-size: 28px; font-weight: 700; color: #1a202c; margin-bottom: 4px; }
  .page-title p  { font-size: 14px; color: #6b7280; }

  /* Alert Banner Styles */
  .alert { padding: 12px 16px; border-radius: 8px; margin-bottom: 24px; display: flex; align-items: center; gap: 12px; font-size: 14px; font-weight: 500; animation: fadeIn 0.3s ease; }
  @keyframes fadeIn { from { opacity: 0; transform: translateY(-10px); } to { opacity: 1; transform: translateY(0); } }
  .alert-success { background-color: #ecfdf5; color: #065f46; border: 1px solid #a7f3d0; }
  .alert-error { background-color: #fef2f2; color: #991b1b; border: 1px solid #fecaca; }
  .error-banner { background: #fee2e2; color: #991b1b; border: 1px solid #fca5a5; border-radius: 8px; padding: 12px 20px; margin-bottom: 20px; font-size: 13px; }

  /* Stats Grid */
  .stats-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 24px; margin-bottom: 24px; }
  .stat-card { background-color: white; border: 1px solid #e5e7eb; border-radius: 12px; padding: 24px; position: relative; overflow: hidden; box-shadow: 0 1px 3px rgba(0,0,0,0.03); height: 120px; display: flex; flex-direction: column; justify-content: center; }
  .stat-title { font-size: 12px; font-weight: 600; color: #6b7280; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 12px; position: relative; z-index: 2; }
  .stat-value-row { display: flex; align-items: baseline; gap: 8px; position: relative; z-index: 2; }
  .stat-num   { font-size: 28px; font-weight: 700; color: #111827; }
  .stat-label { font-size: 13px; color: #6b7280; }
  .badge-available { background-color: #d1fae5; color: #065f46; padding: 4px 10px; border-radius: 12px; font-size: 11px; font-weight: 600; }
  .bg-shape { position: absolute; right: -20%; top: -20%; width: 150px; height: 150px; border-radius: 50%; z-index: 1; }
  .shape-blue   { background-color: #f0f4ff; }
  .shape-green  { background-color: #ecfdf5; }
  .shape-orange { background-color: #fff7ed; }

  /* Table Styles */
  .table-container { background-color: white; border: 1px solid #e5e7eb; border-radius: 12px; box-shadow: 0 1px 3px rgba(0,0,0,0.03); overflow: hidden; }
  .data-table { width: 100%; border-collapse: collapse; text-align: left; }
  .data-table th { background-color: #e2f1ec; padding: 16px 24px; font-size: 12px; font-weight: 700; color: #0b6b59; text-transform: uppercase; letter-spacing: 0.5px; }
  .data-table td { padding: 16px 24px; font-size: 14px; color: #111827; border-bottom: 1px solid #e5e7eb; }
  .empty-state { text-align: center; padding: 60px 20px !important; color: #6b7280; font-size: 14px; }

  /* Buttons */
  .btn-view { background: #0d7f6b; color: white; border: none; padding: 6px 12px; border-radius: 6px; font-size: 12px; cursor: pointer; display: inline-block; transition: opacity 0.2s; }
  .btn-view:hover { opacity: 0.9; }
  .btn-delete { background: #ef4444; color: white; border: none; padding: 6px 12px; border-radius: 6px; font-size: 12px; cursor: pointer; text-decoration: none; display: inline-block; margin-left: 8px; transition: opacity 0.2s; }
  .btn-delete:hover { opacity: 0.9; }

  /* Pagination */
  .pagination-bar { display: flex; justify-content: space-between; align-items: center; padding: 16px 24px; border-top: 1px solid #e5e7eb; }
  .pagination-info { font-size: 13px; color: #6b7280; }
  .pagination-controls { display: flex; align-items: center; gap: 8px; }
  .page-btn { width: 32px; height: 32px; display: flex; align-items: center; justify-content: center; border: none; background: transparent; border-radius: 4px; color: #6b7280; cursor: pointer; font-size: 14px; }
  .page-btn.active { background-color: #0d7f6b; color: white; }

  /* Modal Styles */
  .modal-overlay { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(17, 24, 39, 0.6); display: flex; justify-content: center; align-items: center; z-index: 1000; opacity: 0; visibility: hidden; transition: all 0.3s ease; }
  .modal-overlay.active { opacity: 1; visibility: visible; }
  .modal-card { background: white; width: 100%; max-width: 550px; border-radius: 12px; box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1); transform: translateY(-20px); transition: transform 0.3s ease; overflow: hidden; }
  .modal-overlay.active .modal-card { transform: translateY(0); }
  .modal-header { padding: 20px 24px; border-bottom: 1px solid #e5e7eb; display: flex; justify-content: space-between; align-items: center; background-color: #f8fafc; }
  .modal-header h3 { font-size: 18px; font-weight: 700; color: #111827; }
  .btn-close { background: none; border: none; font-size: 20px; color: #6b7280; cursor: pointer; transition: color 0.2s; }
  .btn-close:hover { color: #ef4444; }
  .modal-body { padding: 24px; }
  .modal-profile-header { display: flex; align-items: center; gap: 16px; margin-bottom: 24px; padding-bottom: 20px; border-bottom: 1px solid #e5e7eb; }
  .modal-avatar { width: 64px; height: 64px; background-color: #e2f1ec; color: #0d7f6b; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 24px; font-weight: 700; text-transform: uppercase;}
  .modal-info h4 { font-size: 18px; font-weight: 700; color: #111827; margin-bottom: 4px; }
  .modal-info p { font-size: 13px; color: #6b7280; margin-bottom: 8px;}
  .modal-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
  .modal-item label { display: block; font-size: 12px; color: #6b7280; text-transform: uppercase; font-weight: 600; margin-bottom: 4px; }
  .modal-item p { font-size: 14px; color: #111827; font-weight: 500; }
</style>

<div id="doctors-root" class="content">

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
                  onclick="window.openDoctorModal(this)"
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

</div>

<div class="modal-overlay" id="viewModal">
  <div class="modal-card">
    <div class="modal-header">
      <h3>Doctor Profile</h3>
      <button class="btn-close" onclick="window.closeDoctorModal()"><i class="fa-solid fa-xmark"></i></button>
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
  /**
   * Injected logic triggered by the main SPA index.jsp file.
   */
  window.__pageInit = function() {

    // Auto-dismiss Alert Boxes without relying on global window.onload
    const alertBox = document.getElementById('alertBox');
    if (alertBox) {
      setTimeout(() => {
        alertBox.style.transition = "opacity 0.5s ease";
        alertBox.style.opacity = "0";
        setTimeout(() => alertBox.remove(), 500);
      }, 4000);
    }

    // Modal Open Logic
    window.openDoctorModal = function(button) {
      const name = button.getAttribute('data-name') || 'N/A';
      const status = button.getAttribute('data-status') || '';

      // Populate Data
      document.getElementById('modalAvatar').innerText = name.charAt(0).toUpperCase();
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
    };

    // Modal Close Logic
    window.closeDoctorModal = function() {
      document.getElementById('viewModal').classList.remove('active');
    };

    // Close when clicking outside the modal content
    const modal = document.getElementById('viewModal');
    if (modal) {
      modal.addEventListener('click', function(event) {
        if (event.target === modal) {
          window.closeDoctorModal();
        }
      });
    }
  };
</script>