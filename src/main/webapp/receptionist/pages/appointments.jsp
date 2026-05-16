<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%--
  JSP FRAGMENT: Injected directly into index.jsp.
  No <html>, <head>, or <body> tags.
--%>

<style>
  /* Scoped styles kept for the fragment components */
  .btn-view { display: inline-block; padding: 6px 14px; background-color: #2554ff; color: white; text-decoration: none; border-radius: 6px; font-size: 13px; font-weight: 600; margin-right: 8px; transition: 0.2s ease; }
  .btn-view:hover { background-color: #1d46d8; }
  .btn-delete { display: inline-block; padding: 6px 14px; background-color: #dc2626; color: white; text-decoration: none; border-radius: 6px; font-size: 13px; font-weight: 600; transition: 0.2s ease; }
  .btn-delete:hover { background-color: #b91c1c; }
  .content { padding: 32px; overflow-y: auto; background-color: #fdfdfd; flex: 1; position: relative; }
  .page-header { margin-bottom: 24px; }
  .page-header h2 { font-size: 24px; font-weight: 700; color: #1a202c; }
  .page-header p { font-size: 14px; color: #6b7280; margin-top: 4px; }
  .stats-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px; margin-bottom: 32px; }
  .stat-card { background-color: white; border: 1px solid #e5e7eb; border-radius: 12px; padding: 24px; }
  .stat-info h3 { font-size: 12px; font-weight: 600; color: #6b7280; text-transform: uppercase; margin-bottom: 12px; }
  .stat-info .value { font-size: 28px; font-weight: 700; color: #111827; }
  .table-container { background-color: white; border: 1px solid #e5e7eb; border-radius: 12px; overflow:hidden;}
  .data-table { width: 100%; border-collapse: collapse; text-align: left; }
  .data-table th { background-color: #e2f1ec; padding: 16px 24px; font-size: 12px; font-weight: 700; color: #0b6b59; text-transform: uppercase; }
  .data-table td { padding: 16px 24px; font-size: 14px; border-bottom: 1px solid #e5e7eb; }
  .empty-state { text-align: center; padding: 40px !important; color: #6b7280; }
</style>

<div id="appointments-root" class="content">
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
        <th>DATE & TIME</th>
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
                        onclick="window.openAppointmentModal(
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

      <button onclick="window.closeAppointmentModal()"
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
</div>

<script>
  /**
   * Injected logic triggered by the main SPA index.jsp file.
   */
  window.__pageInit = function() {

    // Attach modal logic explicitly to the global 'window' object
    // so the inline 'onclick' handlers in the HTML can find them.
    window.openAppointmentModal = function(
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
    };

    window.closeAppointmentModal = function() {
      document.getElementById("appointmentModal").style.display = "none";
    };

    // Close modal when clicking outside of it
    const modal = document.getElementById("appointmentModal");
    if (modal) {
      modal.addEventListener('click', function(event) {
        if (event.target === modal) {
          window.closeAppointmentModal();
        }
      });
    }
  };
</script>