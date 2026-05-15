package Doctor.Controller;

import Doctor.Model.Doctor;
import Doctor.Model.dao.DoctorDAO;
import utils.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;

@WebServlet("/viewDoctor")
public class viewDoctorServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");

        // 1. Validate the ID parameter
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/doctors?error=missing_id");
            return;
        }

        try (Connection con = DBConnection.getConnection()) {
            int userId = Integer.parseInt(idParam.trim());

            // 2. Initialize DAO
            DoctorDAO doctorDAO = new DoctorDAO(con);

            // 3. Fetch the doctor details
            Doctor doctor = doctorDAO.getDoctorById(userId);

            if (doctor != null) {
                // 4. Set doctor object in request and forward to the view page
                request.setAttribute("doctor", doctor);
                request.getRequestDispatcher("/viewDoctor.jsp").forward(request, response);
            } else {
                // Doctor not found in the database
                response.sendRedirect(request.getContextPath() + "/doctors?error=not_found");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/doctors?error=invalid_id");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/doctors?error=db_error");
        }
    }
}