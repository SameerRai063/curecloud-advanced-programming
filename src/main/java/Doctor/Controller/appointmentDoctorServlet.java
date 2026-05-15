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
import java.util.List;

@WebServlet("/appointmentDoctors")
public class appointmentDoctorServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try (Connection con = DBConnection.getConnection()) {

            DoctorDAO doctorDAO = new DoctorDAO(con);

            // Fetch all doctors
            List<Doctor> doctors = doctorDAO.getAllDoctors();

            // Send to JSP (you will selectively use fields there)
            request.setAttribute("doctorList", doctors);

            request.getRequestDispatcher("/patient/history.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
    }
}