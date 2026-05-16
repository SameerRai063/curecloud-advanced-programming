<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Upachaar - Appointments</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    :root { --primary-blue: #2554ff; --primary-teal: #0d7f6b; --bg-light: #f8fafc; --text-dark: #111827; --text-gray: #6b7280; --border-color: #e5e7eb; --sidebar-text-muted: #a0bafc; --table-header-bg: #e2f1ec; --table-header-text: #0b6b59; }
    * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Inter', sans-serif; }
    body { background-color: var(--bg-light); color: var(--text-dark); display: flex; height: 100vh; overflow: hidden; }
    .btn-view {
      display: inline-block;
      padding: 6px 14px;
      background-color: #2554ff;
      color: white;
      text-decoration: none;
      border-radius: 6px;
      font-size: 13px;
      font-weight: 600;
      margin-right: 8px;
      transition: 0.2s ease;
    }

    .btn-view:hover {
      background-color: #1d46d8;
    }

    .btn-delete {
      display: inline-block;
      padding: 6px 14px;
      background-color: #dc2626;
      color: white;
      text-decoration: none;
      border-radius: 6px;
      font-size: 13px;
      font-weight: 600;
      transition: 0.2s ease;
    }

    .btn-delete:hover {
      background-color: #b91c1c;
    }
    .sidebar { width: 250px; background-color: var(--primary-blue); color: white; display: flex; flex-direction: column; justify-content: space-between; flex-shrink: 0; }
    .sidebar-top { padding: 24px 16px; }
    .brand h1 { font-size: 22px; font-weight: 700; margin-bottom: 4px; }
    .brand p { font-size: 12px; color: var(--sidebar-text-muted); margin-bottom: 32px; }
    .nav-menu { list-style: none; }
    .nav-link { display: flex; align-items: center; padding: 12px 16px; color: white; text-decoration: none; font-size: 14px; font-weight: 500; border-radius: 8px; margin-bottom: 4px; }
    .nav-link i { width: 20px; margin-right: 12px; font-size: 16px; text-align: center; }
    .nav-item.active .nav-link { background-color: white; color: var(--primary-blue); }
    .nav-link:hover:not(.active) { background-color: rgba(255, 255, 255, 0.1); }
    .user-profile { display: flex; align-items: center; padding: 16px; border-top: 1px solid rgba(255, 255, 255, 0.1); }
    .avatar { width: 36px; height: 36px; background-color: white; color: var(--primary-blue); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 14px; margin-right: 12px; }
    .user-info h4 { font-size: 13px; font-weight: 600; }
    .user-info p { font-size: 11px; color: var(--sidebar-text-muted); }

    .main-wrapper { flex: 1; display: flex; flex-direction: column; overflow: hidden; position: relative; }
    .topbar { height: 64px; background-color: white; border-bottom: 1px solid var(--border-color); display: flex; align-items: center; justify-content: space-between; padding: 0 32px; }
    .topbar-left { display: flex; gap: 12px; font-size: 16px; font-weight: 600; color: var(--primary-teal); }
    .topbar-left .date { font-size: 13px; color: var(--text-gray); font-weight: 400; }
    .top-search { display: flex; align-items: center; background-color: #f3f4f6; border-radius: 20px; padding: 8px 16px; width: 400px; }
    .top-search input { border: none; background: transparent; outline: none; width: 100%; margin-left: 8px; font-size: 13px;}
    .btn-support { background-color: #f0fdf4; color: var(--primary-teal); border: 1px solid #bbf7d0; border-radius: 20px; padding: 6px 16px; font-size: 13px; cursor: pointer; }

    .content { padding: 32px; overflow-y: auto; background-color: #fdfdfd; flex: 1; position: relative; }
    .page-header { margin-bottom: 24px; }
    .page-header h2 { font-size: 24px; font-weight: 700; color: #1a202c; }
    .page-header p { font-size: 14px; color: var(--text-gray); margin-top: 4px; }

    /* Stats Grid */
    .stats-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px; margin-bottom: 32px; }
    .stat-card { background-color: white; border: 1px solid var(--border-color); border-radius: 12px; padding: 24px; }
    .stat-info h3 { font-size: 12px; font-weight: 600; color: var(--text-gray); text-transform: uppercase; margin-bottom: 12px; }
    .stat-info .value { font-size: 28px; font-weight: 700; color: #111827; }

    /* Table */
    .table-container { background-color: white; border: 1px solid var(--border-color); border-radius: 12px; overflow:hidden;}
    .data-table { width: 100%; border-collapse: collapse; text-align: left; }
    .data-table th { background-color: var(--table-header-bg); padding: 16px 24px; font-size: 12px; font-weight: 700; color: var(--table-header-text); text-transform: uppercase; }
    .data-table td { padding: 16px 24px; font-size: 14px; border-bottom: 1px solid var(--border-color); }
    .empty-state { text-align: center; padding: 40px !important; color: var(--text-gray); }

    /* Floating Action Button */
    .fab { position: absolute; bottom: 40px; right: 40px; width: 56px; height: 56px; background-color: var(--primary-teal); color: white; border-radius: 50%; display: flex; justify-content: center; align-items: center; font-size: 24px; box-shadow: 0 4px 12px rgba(13, 127, 107, 0.3); cursor: pointer; border: none; }

    /* Action Icons */
    .action-icon { margin-right: 12px; font-size: 16px; cursor: pointer; color: var(--text-gray); }
    .action-icon:hover { color: var(--primary-teal); }
  </style>
</head>
<body>
<aside class="sidebar">
  <div class="sidebar-top">
    <div class="brand"><h1>Upachaar</h1><p>Clinical Oversight</p></div>
    <ul class="nav-menu">
      <li class="nav-item">
        <a href="<%= request.getContextPath() %>/Admin-dashboard" class="nav-link">
          <i class="fa-solid fa-border-all"></i> Dashboard</a></li>
      <li class="nav-item">
        <a href="<%= request.getContextPath() %>/doctors" class="nav-link">
          <i class="fa-solid fa-stethoscope"></i> Doctors</a></li>
      <li class="nav-item">
        <a href="<%= request.getContextPath() %>/patients" class="nav-link">
          <i class="fa-solid fa-users"></i> Patients</a></li>
      <li class="nav-item active">
        <a href="${pageContext.request.contextPath}/appointments" class="nav-link">
          <i class="fa-regular fa-calendar"></i> Appointments</a></li>

    </ul>
  </div>
  <div class="user-profile">
    <div class="avatar">${not empty sessionScope.loggedInUser ? sessionScope.loggedInUser.name.substring(0,1) : 'S'}</div>
    <div class="user-info">
      <h4>${not empty sessionScope.loggedInUser ? sessionScope.loggedInUser.name : 'Samir'}</h4>
      <p>${not empty sessionScope.loggedInUser ? sessionScope.loggedInUser.role : 'Super Admin'}</p>
    </div>
  </div>
</aside>

<div class="main-wrapper">
  <header class="topbar">
    <div class="topbar-left">
      Appointments <span style="color:#d1d5db;">|</span>
      <span class="date">${not empty currentDate ? currentDate : 'May 1, 2026'}</span>
    </div>

    <div class="topbar-right">
      <button class="btn-support">Support</button>
    </div>
  </header>

  <main class="content">
    <div class="page-header">
      <h2>Appointment Management</h2>
      <p>Manage and track all hospital appointments across departments.</p>
    </div>

    <div class="stats-grid">
      <div class="stat-card">
        <div class="stat-info">
          <h3>TOTAL APPOINTMENTS</h3>
          <div class="value">${not empty totalAppointments ? totalAppointments : 0}</div>
        </div>
      </div>
      <div class="stat-card" style="background: #f0fdfa;">
        <div class="stat-info">
          <h3>APPOINTMENTS TODAY</h3>
          <div class="value">${not empty appointmentsToday ? appointmentsToday : 0}</div>
        </div>
      </div>
      <div class="stat-card" style="background: #f0fdf4;">
        <div class="stat-info">
          <h3>COMPLETED</h3>
          <div class="value">${not empty completedAppointments ? completedAppointments : 0}</div>
        </div>
      </div>
    </div>

    <div class="table-container">
      <table class="data-table">
        <thead>
        <tr>
          <th>ID</th>
          <th>PATIENT</th>
          <th>DOCTOR</th>
          <th>DEPARTMENT</th>
          <th>DATE</th>
          <th>STATUS</th>
          <th>ACTIONS</th>
        </tr>
        </thead>
        <tbody>
        <c:choose>
          <c:when test="${empty appointmentList}">
            <tr>
              <td colspan="7" class="empty-state">No appointments found</td>
            </tr>
          </c:when>
          <c:otherwise>
            <c:forEach var="appointment" items="${appointmentList}">
              <tr>
                <td>${appointment.id}</td>
                <td>${appointment.patientName}</td>
                <td>${appointment.doctorName}</td>
                <td>${appointment.department}</td>
                <td>${appointment.appointmentDate}</td>
                <td>${appointment.status}</td>
                <td>
                  <button
                          type="button"
                          class="btn-view"
                          onclick="openAppointmentModal(
                                  '${appointment.id}',
                                  '${appointment.patientName}',
                                  '${appointment.doctorName}',
                                  '${appointment.department}',
                                  '${appointment.appointmentDate}',
                                  '${appointment.appointmentTime}',
                                  '${appointment.status}',
                                  '${appointment.reason}'
                                  )">
                    View
                  </button>

                  <a href="${pageContext.request.contextPath}/deleteAppointment?id=${appointment.id}"
                     class="btn-delete"
                     onclick="return confirm('Are you sure you want to delete appointment ID ${appointment.id}? This action cannot be undone.');">
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

    <button class="fab" onclick="window.location.href='addAppointment.jsp'"><i class="fa-solid fa-plus"></i></button>
  </main>
</div>
<!-- VIEW APPOINTMENT MODAL -->
<div id="appointmentModal"
     style="display:none;
            position:fixed;
            top:0;
            left:0;
            width:100%;
            height:100%;
            background:rgba(0,0,0,0.5);
            z-index:9999;
            justify-content:center;
            align-items:center;">

  <div style="
        background:white;
        width:500px;
        max-width:90%;
        border-radius:12px;
        padding:30px;
        position:relative;
        box-shadow:0 10px 30px rgba(0,0,0,0.2);
    ">

    <button onclick="closeAppointmentModal()"
            style="
                    position:absolute;
                    top:15px;
                    right:15px;
                    border:none;
                    background:none;
                    font-size:20px;
                    cursor:pointer;
                ">
      ×
    </button>

    <h2 style="margin-bottom:20px;color:#2554ff;">
      Appointment Details
    </h2>

    <div style="display:flex;flex-direction:column;gap:14px;">

      <div>
        <strong>ID:</strong>
        <span id="modalAppointmentId"></span>
      </div>

      <div>
        <strong>Patient:</strong>
        <span id="modalPatientName"></span>
      </div>

      <div>
        <strong>Doctor:</strong>
        <span id="modalDoctorName"></span>
      </div>

      <div>
        <strong>Department:</strong>
        <span id="modalDepartment"></span>
      </div>

      <div>
        <strong>Date:</strong>
        <span id="modalDate"></span>
      </div>

      <div>
        <strong>Time:</strong>
        <span id="modalTime"></span>
      </div>

      <div>
        <strong>Status:</strong>
        <span id="modalStatus"></span>
      </div>

      <div>
        <strong>Reason:</strong>
        <span id="modalReason"></span>
      </div>

    </div>
  </div>
</div>
<script>
  function openAppointmentModal(
          id,
          patient,
          doctor,
          department,
          date,
          time,
          status,
          reason
  ) {

    document.getElementById("modalAppointmentId").innerText = id;
    document.getElementById("modalPatientName").innerText = patient;
    document.getElementById("modalDoctorName").innerText = doctor;
    document.getElementById("modalDepartment").innerText = department;
    document.getElementById("modalDate").innerText = date;
    document.getElementById("modalTime").innerText = time;
    document.getElementById("modalStatus").innerText = status;
    document.getElementById("modalReason").innerText = reason;

    document.getElementById("appointmentModal").style.display = "flex";
  }

  function closeAppointmentModal() {
    document.getElementById("appointmentModal").style.display = "none";
  }

  window.onclick = function(event) {
    const modal = document.getElementById("appointmentModal");

    if (event.target === modal) {
      closeAppointmentModal();
    }
  }
</script>
</body>
</html>