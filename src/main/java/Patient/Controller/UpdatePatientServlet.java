package Patient.Controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.Connection;

import utils.DBConnection;
import User.Model.User;
import User.Model.dao.UserDAO;
import Patient.Model.Patient;
import Patient.Model.dao.PatientDAO;

@WebServlet("/update-patient")
public class UpdatePatientServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User loggedInUser = (session != null) ? (User) session.getAttribute("loggedInUser") : null;

        if (loggedInUser == null) {
            response.sendRedirect("login.jsp?error=unauthorized");
            return;
        }

        Connection con = null;
        try {
            int targetUserId = 0;
            String userRole = loggedInUser.getRole().toLowerCase();

            // AUTHORIZATION: Patient (Self), Admin, or Receptionist
            if (userRole.equals("patient")) {
                targetUserId = loggedInUser.getId(); // Self update
            } else if (userRole.equals("admin") || userRole.equals("receptionist")) {
                targetUserId = Integer.parseInt(request.getParameter("targetUserId")); // Staff updating patient
            } else {
                response.sendRedirect("login.jsp?error=unauthorized");
                return;
            }

            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            // Update User Table
            User user = new User();
            user.setId(targetUserId);
            user.setName(request.getParameter("name"));
            user.setGender(request.getParameter("gender"));
            user.setAddress(request.getParameter("address"));
            user.setPhone(request.getParameter("phone"));
            boolean userUpdated = new UserDAO(con).updateUser(user);

            // Update Patient Table
            Patient patient = new Patient();
            patient.setUserId(targetUserId);
            patient.setBloodGroup(request.getParameter("bloodGroup"));
            patient.setActive(request.getParameter("isActive") != null ? Boolean.parseBoolean(request.getParameter("isActive")) : true);
            boolean patientUpdated = new PatientDAO(con).updatePatient(patient);

            if (userUpdated && patientUpdated) {
                con.commit();
                if (userRole.equals("patient")) {
                    loggedInUser.setName(user.getName()); // Update session name
                    response.sendRedirect("patient_dashboard.jsp?success=updated");
                } else {
                    response.sendRedirect("view-patients?success=updated");
                }
            } else {
                con.rollback();
                response.sendRedirect("edit_patient.jsp?error=failed");
            }
        } catch (Exception e) {
            try { if (con != null) con.rollback(); } catch (Exception ex) {}
            e.printStackTrace();
            response.sendRedirect("edit_patient.jsp?error=exception");
        } finally {
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}