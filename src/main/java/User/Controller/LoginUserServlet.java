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

            // 2. Check if user exists
            if (user != null) {

                // Normalize $2y$ / $2b$ prefixes to $2a$ (jBCrypt only understands $2a$)
                String storedHash = user.getPassword();
                if (storedHash != null && (storedHash.startsWith("$2y$") || storedHash.startsWith("$2b$"))) {
                    storedHash = "$2a$" + storedHash.substring(4);
                }

                // 3. Verify password
                if (BCrypt.checkpw(plainPassword, storedHash)) {

                    // Login successful — create session
                    HttpSession session = request.getSession();
                    session.setAttribute("loggedInUser", user);
                    session.setAttribute("userName", user.getName());
                    session.setAttribute("userRole", user.getRole());

                    String role = user.getRole();

                    if ("patient".equalsIgnoreCase(role)) {
                        response.sendRedirect(ctx + "/patient/dashboard.jsp");

                    } else if ("admin".equalsIgnoreCase(role)) {
                        response.sendRedirect(ctx + "/Admin-dashboard");

                    } else if ("doctor".equalsIgnoreCase(role)) {
                        response.sendRedirect(ctx + "/Admin-dashboard");

                    } else if ("receptionist".equalsIgnoreCase(role)) {
                        response.sendRedirect(ctx + "/Admin-dashboard");

                    } else {
                        response.sendRedirect(ctx + "/login.jsp");
                    }

                } else {
                    // Wrong password
                    response.sendRedirect(ctx + "/login.jsp?error=invalid_credentials");
                }

            } else {
                // No user found with that email
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