package Patient.Controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

import java.io.IOException;
import java.sql.Connection;

import org.mindrot.jbcrypt.BCrypt;

import utils.DBConnection;
import User.Model.User;
import User.Model.dao.UserDAO;
import Patient.Model.Patient;
import Patient.Model.dao.PatientDAO;

@WebServlet("/register-patient")
public class AddPatientServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Connection con = null;

        try {
            // ===== GET FORM DATA =====
            String name = request.getParameter("fullName");
            String gender = request.getParameter("gender");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String bloodGroup = request.getParameter("bloodGroup");

            // ===== BCRYPT PASSWORD =====
            String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

            // ===== DB CONNECTION =====
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            // ===== USER OBJECT =====
            User user = new User();
            user.setName(name);
            user.setGender(gender);
            user.setEmail(email);
            user.setPassword(hashedPassword);
            user.setRole("patient");

            // ===== USER DAO (INTERFACE USED) =====
            UserDAO userDAO = new UserDAO(con);
            int userId = userDAO.addUser(user);

            // ===== PATIENT OBJECT =====
            Patient patient = new Patient();
            patient.setUserId(userId);
            patient.setBloodGroup(bloodGroup);
            patient.setActive(false);

            // ===== PATIENT DAO =====
            PatientDAO patientDAO = new PatientDAO(con);
            boolean ok = patientDAO.addPatient(patient);

            // ===== TRANSACTION CONTROL =====
            if (ok && userId > 0) {
                con.commit();
                response.sendRedirect("login.jsp?success=registered");
            } else {
                con.rollback();
                response.sendRedirect("register.jsp?error=failed");
            }

        } catch (Exception e) {
            try {
                if (con != null) con.rollback();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            e.printStackTrace();
            response.sendRedirect("register.jsp?error=exception");

        } finally {
            try {
                if (con != null) con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}