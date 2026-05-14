package User.Controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.Connection;

import org.mindrot.jbcrypt.BCrypt;
import utils.DBConnection;
import User.Model.User;
import User.Model.dao.UserDAO;

@WebServlet("/login")
public class LoginUserServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email         = request.getParameter("email");
        String plainPassword = request.getParameter("password");
        String ctx           = request.getContextPath();

        Connection con = null;

        try {
            con = DBConnection.getConnection();
            UserDAO userDAO = new UserDAO(con);

            // 1. Fetch the user from the database by email
            User user = userDAO.getUserByEmail(email);

            // 2. Check if user exists AND password matches
            if (user != null && BCrypt.checkpw(plainPassword, user.getPassword())) {

                // Login successful — create session
                HttpSession session = request.getSession();
                session.setAttribute("loggedInUser", user);

                // FIX: store name and role so JSP sidebar can display them
                session.setAttribute("userName", user.getName());
                session.setAttribute("userRole", user.getRole());

                // FIX: redirect through /dashboard servlet (not directly to JSP)
                //      so dashboard stats are fetched before the page renders
                String role = user.getRole();

                if ("patient".equalsIgnoreCase(role)) {
                    response.sendRedirect(ctx + "/Admin-dashboard");

                } else if ("admin".equalsIgnoreCase(role)) {
                    response.sendRedirect(ctx + "/Admin-dashboard");

                } else if ("doctor".equalsIgnoreCase(role)) {
                    response.sendRedirect(ctx + "/Admin-dashboard");

                } else if ("receptionist".equalsIgnoreCase(role)) {
                    response.sendRedirect(ctx + "/Admin-dashboard");

                } else {
                    // Fallback for unknown roles
                    response.sendRedirect(ctx + "/login.jsp");
                }

            } else {
                // Login failed — wrong email or password
                response.sendRedirect(ctx + "/login.jsp?error=invalid_credentials");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(ctx + "/login.jsp?error=system_error");

        } finally {
            try {
                if (con != null) con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}