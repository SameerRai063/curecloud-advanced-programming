package Receptionist.Controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

import java.io.IOException;
import java.sql.Connection;

import org.mindrot.jbcrypt.BCrypt;

import utils.DBConnection;
import User.Model.User;
import User.Model.dao.UserDAO;
import Receptionist.Model.Receptionist;
import Receptionist.Model.dao.ReceptionistDAO;

@WebServlet("/add-receptionist")
public class addReceptionistServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Connection con = null;

        try {
            // ===== 1. GET USER FORM DATA =====
            String name = request.getParameter("name");
            String gender = request.getParameter("gender");
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            // ===== 2. GET RECEPTIONIST-SPECIFIC FORM DATA =====
            String status = request.getParameter("status");

            // ===== 3. BCRYPT PASSWORD =====
            String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

            // ===== 4. DB CONNECTION & TRANSACTION SETUP =====
            con = DBConnection.getConnection();
            con.setAutoCommit(false); // Start transaction

            // ===== 5. CREATE USER OBJECT =====
            User user = new User();
            user.setName(name);
            user.setGender(gender);
            user.setEmail(email);
            user.setPassword(hashedPassword);
            user.setRole("receptionist"); // Hardcode the role

            // ===== 6. SAVE USER =====
            UserDAO userDAO = new UserDAO(con);
            int userId = userDAO.addUser(user);

            // ===== 7. CREATE RECEPTIONIST OBJECT =====
            Receptionist receptionist = new Receptionist();
            receptionist.setUserId(userId);
            receptionist.setStatus(status);

            // ===== 8. SAVE RECEPTIONIST =====
            ReceptionistDAO receptionistDAO = new ReceptionistDAO(con);
            boolean isReceptionistAdded = receptionistDAO.addReceptionist(receptionist);

            // ===== 9. TRANSACTION CONTROL =====
            if (isReceptionistAdded && userId > 0) {
                con.commit(); // Success! Save everything.
                response.sendRedirect("admin_dashboard.jsp?success=receptionist_added");
            } else {
                con.rollback(); // Failed! Undo User creation.
                response.sendRedirect("add_receptionist.jsp?error=failed");
            }

        } catch (Exception e) {
            try {
                if (con != null) con.rollback();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            response.sendRedirect("add_receptionist.jsp?error=exception");

        } finally {
            try {
                if (con != null) con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}