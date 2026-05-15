package Receptionist.Controller;

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
import Receptionist.Model.Receptionist;
import Receptionist.Model.dao.ReceptionistDAO;

@WebServlet("/add-receptionist")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
        maxFileSize = 1024 * 1024 * 10,       // 10MB
        maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class addReceptionistServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "uploads" + File.separator + "receptionists";


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Connection con = null;
        try {
            // 1. Process Profile Image
            String fileName = "default_receptionist.png";
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
            user.setRole("receptionist"); // Explicitly setting the role

            String dobStr = request.getParameter("dob");
            if (dobStr != null && !dobStr.isEmpty()) {
                user.setDob(Date.valueOf(dobStr));
            }

            // 3. Map Receptionist Details
            Receptionist receptionist = new Receptionist();
            receptionist.setUser(user);
            receptionist.setStatus(request.getParameter("status"));

            // 4. Database Transaction
            con = DBConnection.getConnection();
            ReceptionistDAO receptionistDAO = new ReceptionistDAO(con);

            boolean success = receptionistDAO.addReceptionist(receptionist);

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