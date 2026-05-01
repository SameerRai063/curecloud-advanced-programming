package Doctor.Controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

import java.io.IOException;
import java.sql.Connection;

import org.mindrot.jbcrypt.BCrypt;

import utils.DBConnection;
import User.Model.User;
import User.Model.dao.UserDAO;
import Doctor.Model.Doctor;
import Doctor.Model.dao.DoctorDAO;

@WebServlet("/add-doctor")
public class addDoctorServlet extends HttpServlet {

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

            // ===== 2. GET DOCTOR-SPECIFIC FORM DATA =====
            String status = request.getParameter("status");
            String qualifications = request.getParameter("qualifications");
            String department = request.getParameter("department");
            int experienceYears = Integer.parseInt(request.getParameter("experienceYears"));

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
            user.setRole("doctor"); // Hardcode the role

            // ===== 6. SAVE USER =====
            UserDAO userDAO = new UserDAO(con);
            int userId = userDAO.addUser(user);

            // ===== 7. CREATE DOCTOR OBJECT =====
            Doctor doctor = new Doctor();
            doctor.setUserId(userId);
            doctor.setStatus(status);
            doctor.setQualifications(qualifications);
            doctor.setDepartment(department);
            doctor.setExperienceYears(experienceYears);

            // ===== 8. SAVE DOCTOR =====
            DoctorDAO doctorDAO = new DoctorDAO(con);
            boolean isDoctorAdded = doctorDAO.addDoctor(doctor);

            // ===== 9. TRANSACTION CONTROL =====
            if (isDoctorAdded && userId > 0) {
                con.commit(); // Success! Save everything.
                response.sendRedirect("admin_dashboard.jsp?success=doctor_added");
            } else {
                con.rollback(); // Failed! Undo User creation.
                response.sendRedirect("add_doctor.jsp?error=failed");
            }

        } catch (Exception e) {
            try {
                if (con != null) con.rollback();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            response.sendRedirect("add_doctor.jsp?error=exception");

        } finally {
            try {
                if (con != null) con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}