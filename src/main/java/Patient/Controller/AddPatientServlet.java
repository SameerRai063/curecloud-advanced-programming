package Patient.Controller;

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
import Patient.Model.Patient;
import Patient.Model.dao.PatientDAO;

@WebServlet("/add-patient")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
public class AddPatientServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "uploads" + File.separator + "patients";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Connection con = null;
        try {
            // 1. Process Profile Image
            String fileName = "default_patient.png";
            Part filePart = request.getPart("profileImage");

            if (filePart != null && filePart.getSize() > 0) {
                String originalName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                fileName = System.currentTimeMillis() + "_" + originalName;

                String applicationPath = getServletContext().getRealPath("");
                String uploadFilePath = applicationPath + File.separator + UPLOAD_DIR;

                File fileSaveDir = new File(uploadFilePath);
                if (!fileSaveDir.exists()) fileSaveDir.mkdirs();

                filePart.write(uploadFilePath + File.separator + fileName);
            }

            // 2. Map User Details
            User user = new User();
            user.setName(request.getParameter("name"));
            user.setEmail(request.getParameter("email"));
            user.setPassword(request.getParameter("password"));
            user.setPhone(request.getParameter("phone"));
            user.setGender(request.getParameter("gender"));
            user.setAddress(request.getParameter("address"));
            user.setProfileImage(fileName);
            user.setRole("patient"); // Explicitly setting role

            String dobStr = request.getParameter("dob");
            if (dobStr != null && !dobStr.isEmpty()) {
                user.setDob(Date.valueOf(dobStr));
            }

            // 3. Map Patient Details
            Patient patient = new Patient();
            patient.setUser(user);
            patient.setBloodGroup(request.getParameter("bloodGroup"));
            patient.setActive(true); // Default new patients to active

            // 4. Database Transaction
            con = DBConnection.getConnection();
            PatientDAO patientDAO = new PatientDAO(con);

            boolean success = patientDAO.addPatient(patient);

            // 5. Success/Error Handling
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