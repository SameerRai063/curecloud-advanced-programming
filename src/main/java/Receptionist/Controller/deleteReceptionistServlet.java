package Receptionist.Controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.Connection;

import utils.DBConnection;
import Receptionist.Model.dao.ReceptionistDAO;
import User.Model.dao.UserDAO;

@WebServlet("/delete-receptionist")
public class deleteReceptionistServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Connection con = null;

        try {
            int userId = Integer.parseInt(request.getParameter("id"));

            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            ReceptionistDAO receptionistDAO = new ReceptionistDAO(con);
            UserDAO userDAO = new UserDAO(con);

            // 1. Delete Receptionist first
            boolean isReceptionistDeleted = receptionistDAO.deleteReceptionist(userId);

            // 2. Delete User second
            boolean isUserDeleted = userDAO.deleteUser(userId);

            if (isReceptionistDeleted && isUserDeleted) {
                con.commit();
                response.sendRedirect("view-receptionists?success=deleted");
            } else {
                con.rollback();
                response.sendRedirect("view-receptionists?error=delete_failed");
            }

        } catch (Exception e) {
            try { if (con != null) con.rollback(); } catch (Exception ex) { ex.printStackTrace(); }
            e.printStackTrace();
            response.sendRedirect("view-receptionists?error=system_error");
        } finally {
            try { if (con != null) con.close(); } catch (Exception e) { e.printStackTrace(); }
        }
    }
}