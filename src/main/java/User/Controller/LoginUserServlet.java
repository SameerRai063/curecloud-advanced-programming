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

        String email = request.getParameter("email");
        String plainPassword = request.getParameter("password");

        Connection con = null;

        try {
            con = DBConnection.getConnection();
            UserDAO userDAO = new UserDAO(con);

            // 1. Fetch the user from the database by email
            User user = userDAO.getUserByEmail(email);

            // 2. Check if user exists AND if the plain password matches the hashed password
            if (user != null && BCrypt.checkpw(plainPassword, user.getPassword())) {

                // Login Successful! Create the session
                HttpSession session = request.getSession();
                session.setAttribute("loggedInUser", user);

                // Route to the correct dashboard based on their role
                String role = user.getRole();

                if ("patient".equalsIgnoreCase(role)) {
                    response.sendRedirect("patient_dashboard.jsp");

                } else if ("admin".equalsIgnoreCase(role)) {
                    response.sendRedirect("admin_dashboard.jsp");

                } else if ("doctor".equalsIgnoreCase(role)) {
                    response.sendRedirect("doctor_dashboard.jsp");

                } else if ("receptionist".equalsIgnoreCase(role)) {
                    response.sendRedirect("receptionist_dashboard.jsp");

                } else {
                    // Fallback for unknown roles
                    response.sendRedirect("index.jsp");
                }

            } else {
                // Login Failed! Incorrect email or password
                response.sendRedirect("login.jsp?error=invalid_credentials");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=system_error");

        } finally {
            // Ensure the database connection is closed to prevent memory leaks
            try {
                if (con != null) {
                    con.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}