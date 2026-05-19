package User.Controller;

import Doctor.Model.dao.DoctorDAO;
import Patient.Model.dao.PatientDAO;
import Receptionist.Model.dao.ReceptionistDAO;
import Payment.Model.dao.PaymentDAO;
import utils.DashboardActivityService;
import utils.DBConnection;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.Connection;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/Admin-dashboard")
public class AdminDashboardServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(AdminDashboardServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Guard — redirect to login if no active session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try (Connection con = DBConnection.getConnection()) {

            // Instantiate DAOs
            DoctorDAO       doctorDAO       = new DoctorDAO(con);
            PatientDAO      patientDAO      = new PatientDAO(con);
            ReceptionistDAO receptionistDAO = new ReceptionistDAO(con);
            PaymentDAO      paymentDAO      = new PaymentDAO(con);

            // Fetch stats
            int    totalDoctors       = doctorDAO.getTotalDoctors();
            int    totalPatients      = patientDAO.getTotalPatients();
            int    totalReceptionists = receptionistDAO.getTotalReceptionists();
            double totalRevenue       = paymentDAO.getTotalRevenue();

            // Set as request attributes for the JSP
            request.setAttribute("totalDoctors",       totalDoctors);
            request.setAttribute("totalPatients",      totalPatients);
            request.setAttribute("totalReceptionists", totalReceptionists);
            request.setAttribute("totalRevenue",       totalRevenue);
            DashboardActivityService.attachRecentActivity(con, request);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unable to load admin dashboard", e);
            request.setAttribute("errorMessage", e.getMessage());
        }

        forwardDashboard(request, response);
    }

    private void forwardDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        RequestDispatcher rd = request.getRequestDispatcher("/admin/dashboard.jsp");
        rd.forward(request, response);
    }
}
