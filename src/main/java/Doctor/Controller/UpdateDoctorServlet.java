package Doctor.Controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.Connection;

import utils.DBConnection;
import User.Model.User;
import User.Model.dao.UserDAO;
import Doctor.Model.Doctor;
import Doctor.Model.dao.DoctorDAO;

@WebServlet("/update-doctor")
public class UpdateDoctorServlet extends HttpServlet {
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

            // AUTHORIZATION: Doctor (Self) or Admin
            if (userRole.equals("doctor")) {
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

            // Update Doctor Table
            Doctor doctor = new Doctor();
            doctor.setUserId(targetUserId);
            doctor.setStatus(request.getParameter("status"));
            doctor.setQualifications(request.getParameter("qualifications"));
            doctor.setDepartment(request.getParameter("department"));
            doctor.setExperienceYears(Integer.parseInt(request.getParameter("experienceYears")));
            boolean doctorUpdated = new DoctorDAO(con).updateDoctor(doctor);

            if (userUpdated && doctorUpdated) {
                con.commit();
                if (userRole.equals("doctor")) {
                    loggedInUser.setName(user.getName());
                    response.sendRedirect("doctor_dashboard.jsp?success=updated");
                } else {
                    response.sendRedirect("view-doctors?success=updated");
                }
            } else {
                con.rollback();
                response.sendRedirect("edit_doctor.jsp?error=failed");
            }
        } catch (Exception e) {
            try { if (con != null) con.rollback(); } catch (Exception ex) {}
            e.printStackTrace();
            response.sendRedirect("edit_doctor.jsp?error=exception");
        } finally {
            try { if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}