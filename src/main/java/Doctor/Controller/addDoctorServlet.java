package Doctor.Controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.Date;

import utils.DBConnection;
import User.Model.User;
import Doctor.Model.Doctor;
import Doctor.Model.dao.DoctorDAO;

@WebServlet("/add-doctor")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
        maxFileSize = 1024 * 1024 * 10,       // 10MB
        maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class addDoctorServlet extends HttpServlet { // Changed to Uppercase

    private static final String UPLOAD_DIR = "uploads" + File.separator + "doctors";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Connection con = null;
        try {
            // 1. Handle Image
            String fileName = "default_doctor.png";
            Part filePart = request.getPart("profileImage");
            if (filePart != null && filePart.getSize() > 0) {
                fileName = System.currentTimeMillis() + "_" + Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;

                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdirs();
                filePart.write(uploadPath + File.separator + fileName);
            }

            // 2. Build User
            User user = new User();
            user.setName(request.getParameter("name"));
            user.setEmail(request.getParameter("email"));
            user.setPassword(request.getParameter("password"));
            user.setPhone(request.getParameter("phone"));
            user.setGender(request.getParameter("gender"));
            user.setAddress(request.getParameter("address"));
            user.setProfileImage(fileName);
            user.setRole("doctor");

            String dobStr = request.getParameter("dob");
            if (dobStr != null && !dobStr.isEmpty()) {
                user.setDob(Date.valueOf(dobStr));
            }

            // 3. Build Doctor
            Doctor doctor = new Doctor();
            doctor.setUser(user);
            doctor.setQualifications(request.getParameter("qualifications"));
            doctor.setDepartment(request.getParameter("department"));
            doctor.setStatus(request.getParameter("status")); // Will capture "Active" or "On Leave"

            String expStr = request.getParameter("experienceYears");
            doctor.setExperienceYears(expStr != null ? Integer.parseInt(expStr) : 0);

            // 4. DB Operations
            con = DBConnection.getConnection();
            DoctorDAO doctorDAO = new DoctorDAO(con);
            boolean success = doctorDAO.addDoctor(doctor);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/Admin-dashboard?success=1");
            } else {
                response.sendRedirect(request.getContextPath() + "/Admin-dashboard?error=failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/Admin-dashboard?error=exception");
        } finally {
            try { if (con != null) con.close(); } catch (Exception ignore) {}
        }
    }
}