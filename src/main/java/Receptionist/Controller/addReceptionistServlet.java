package Receptionist.Controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.Date;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import User.Model.User;
import Receptionist.Model.Receptionist;
import utils.UserService;

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
                if (!fileSaveDir.exists() && !fileSaveDir.mkdirs()) {
                    throw new IOException("Unable to create receptionist upload directory.");
                }

                filePart.write(uploadFilePath + File.separator + fileName);
            }

            // 2. Map User Details
            User user = new User();
            user.setName(request.getParameter("name") != null ? request.getParameter("name").trim() : null);
            user.setEmail(request.getParameter("email") != null ? request.getParameter("email").trim() : null);
            user.setPassword(request.getParameter("password") != null ? request.getParameter("password").trim() : null);
            user.setPhone(request.getParameter("phone") != null ? request.getParameter("phone").trim() : null);
            user.setGender(request.getParameter("gender") != null ? request.getParameter("gender").trim() : null);
            user.setAddress(request.getParameter("address") != null ? request.getParameter("address").trim() : null);
            user.setProfileImage(fileName);
            user.setRole("receptionist"); // Explicitly setting the role

            String dobStr = request.getParameter("dob");
            if (dobStr != null && !dobStr.isEmpty()) {
                user.setDob(Date.valueOf(dobStr));
            }

            // 3. Map Receptionist Details
            Receptionist receptionist = new Receptionist();
            receptionist.setUser(user);
            //receptionist.setStatus(request.getParameter("status"));

            // 4. Database transaction via Hibernate
            UserService userService = new UserService();
            int userId = userService.createReceptionist(user, receptionist);

            // 5. Success/Error Handling
            if (userId > 0) {
                response.sendRedirect(request.getContextPath() + "/Admin-dashboard?success=receptionist_added");
            } else {
                response.sendRedirect(request.getContextPath() + "/Admin-dashboard?error=receptionist_failed");
            }

        } catch (IllegalArgumentException e) {
            String message = URLEncoder.encode(e.getMessage(), StandardCharsets.UTF_8);
            response.sendRedirect(request.getContextPath() + "/Admin-dashboard?error=validation&message=" + message);
        } catch (Exception e) {
            String message = URLEncoder.encode(e.getMessage() != null ? e.getMessage() : "Unable to save receptionist.", StandardCharsets.UTF_8);
            response.sendRedirect(request.getContextPath() + "/Admin-dashboard?error=exception&message=" + message);
        }
    }
}
