package Patient.Controller;

import Patient.Model.Patient;
import Patient.Model.dao.PatientDAO;
import User.Model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/updatePatient")
public class updatePatientProfile extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private PatientDAO patientDAO;

    @Override
    public void init() {
        patientDAO = new PatientDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Check login
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User loggedInUser = (User) session.getAttribute("loggedInUser");
        int userId = loggedInUser.getId();

        // Read form fields
        String name            = request.getParameter("name");
        String phone           = request.getParameter("phone");
        String gender          = request.getParameter("gender");
        String address         = request.getParameter("address");
        String bloodGroup      = request.getParameter("bloodGroup");
        String currentPassword = request.getParameter("currentPassword");
        String newPassword     = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validate passwords match before hitting DB
        if (newPassword != null && !newPassword.isBlank()) {
            if (!newPassword.equals(confirmPassword)) {
                session.setAttribute("error", "New passwords do not match.");
                response.sendRedirect(
                        request.getContextPath() + "/patientProfile");
                return;
            }
        }

        try {
            // Build User object
            User updatedUser = new User();
            updatedUser.setId(userId);
            updatedUser.setName(name);
            updatedUser.setPhone(phone);
            updatedUser.setGender(gender);
            updatedUser.setAddress(address);
            updatedUser.setEmail(loggedInUser.getEmail());

            // Build Patient object
            Patient updatedPatient = new Patient();
            updatedPatient.setUserId(userId);
            updatedPatient.setBloodGroup(bloodGroup);
            updatedPatient.setUser(updatedUser);

            // Call DAO
            boolean success = patientDAO.updatePatientProfile(
                    updatedPatient, currentPassword, newPassword);

            if (success) {
                // Refresh session with updated user data
                loggedInUser.setName(name);
                loggedInUser.setPhone(phone);
                loggedInUser.setGender(gender);
                loggedInUser.setAddress(address);
                session.setAttribute("loggedInUser", loggedInUser);
                session.setAttribute("success", "Profile updated successfully.");
            } else {
                session.setAttribute("error", "Current password is incorrect.");
            }

            response.sendRedirect(
                    request.getContextPath() + "/patientProfile");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Something went wrong. Please try again.");
            response.sendRedirect(
                    request.getContextPath() + "/patientProfile");
        }
    }
}