package Receptionist.Controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.Connection;

import utils.DBConnection;
import User.Model.User;
import User.Model.dao.UserDAO;
import Receptionist.Model.Receptionist;
import Receptionist.Model.dao.ReceptionistDAO;

@WebServlet("/update-receptionist")
public class UpdateReceptionistServlet extends HttpServlet {
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

            // AUTHORIZATION: Receptionist (Self) or Admin
            if (userRole.equals("receptionist")) {
                targetUserId = loggedInUser.getId();
            } else if (userRole.equals("admin")) {
                targetUserId = Integer.parseInt(request.getParameter("targetUserId"));
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

            // Update Receptionist Table
            Receptionist receptionist = new Receptionist();
            receptionist.setUserId(targetUserId);
            receptionist.setStatus(request.getParameter("status"));
            boolean receptionistUpdated = new ReceptionistDAO(con).updateReceptionist(receptionist);

            if (userUpdated && receptionistUpdated) {
                con.commit();
                if (userRole.equals("receptionist")) {
                    loggedInUser.setName(user.getName());
                    response.sendRedirect("receptionist_dashboard.jsp?success=updated");
                } else {
                    response.sendRedirect("view-receptionists?success=updated");
                }
            } else {
                con.rollback();
                response.sendRedirect("edit_receptionist.jsp?error=failed");
            }
        } catch (Exception e) {
            try { if (con != null) con.rollback(); } catch (Exception ex) {}
            e.printStackTrace();
            response.sendRedirect("edit_receptionist.jsp?error=exception");
        } finally {
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}