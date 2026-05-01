package Patient.Controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.Connection;

import utils.DBConnection;
import Patient.Model.dao.PatientDAO;
import User.Model.dao.UserDAO;

@WebServlet("/delete-patient")
public class DeletePatientServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Connection con = null;

        try {
            int userId = Integer.parseInt(request.getParameter("id"));

            con = DBConnection.getConnection();
            con.setAutoCommit(false); // Start transaction

            PatientDAO patientDAO = new PatientDAO(con);
            UserDAO userDAO = new UserDAO(con);

            // 1. Delete the child record FIRST
            boolean isPatientDeleted = patientDAO.deletePatient(userId);

            // 2. Delete the parent record SECOND
            boolean isUserDeleted = userDAO.deleteUser(userId);

            if (isPatientDeleted && isUserDeleted) {
                con.commit();
                response.sendRedirect("view-patients?success=deleted");
            } else {
                con.rollback();
                response.sendRedirect("view-patients?error=delete_failed");
            }

        } catch (Exception e) {
            try { if (con != null) con.rollback(); } catch (Exception ex) { ex.printStackTrace(); }
            e.printStackTrace();
            response.sendRedirect("view-patients?error=system_error");
        } finally {
            try { if (con != null) con.close(); } catch (Exception e) { e.printStackTrace(); }
        }
    }
}