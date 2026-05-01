package Doctor.Controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.Connection;

import utils.DBConnection;
import Doctor.Model.dao.DoctorDAO;
import User.Model.dao.UserDAO;

@WebServlet("/delete-doctor")
public class deleteDoctorServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Connection con = null;

        try {
            int userId = Integer.parseInt(request.getParameter("id"));

            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            DoctorDAO doctorDAO = new DoctorDAO(con);
            UserDAO userDAO = new UserDAO(con);

            // 1. Delete Doctor first
            boolean isDoctorDeleted = doctorDAO.deleteDoctor(userId);

            // 2. Delete User second
            boolean isUserDeleted = userDAO.deleteUser(userId);

            if (isDoctorDeleted && isUserDeleted) {
                con.commit();
                response.sendRedirect("view-doctors?success=deleted");
            } else {
                con.rollback();
                response.sendRedirect("view-doctors?error=delete_failed");
            }

        } catch (Exception e) {
            try { if (con != null) con.rollback(); } catch (Exception ex) { ex.printStackTrace(); }
            e.printStackTrace();
            response.sendRedirect("view-doctors?error=system_error");
        } finally {
            try { if (con != null) con.close(); } catch (Exception e) { e.printStackTrace(); }
        }
    }
}