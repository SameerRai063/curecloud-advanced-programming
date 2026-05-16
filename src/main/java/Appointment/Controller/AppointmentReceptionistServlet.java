package Appointment.Controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import Appointment.Model.Appointment;
import Appointment.Model.dao.AppointmentDAO;

import java.io.IOException;
import java.util.List;

@WebServlet("/receptionist/appointments")
public class AppointmentReceptionistServlet extends HttpServlet {

    private AppointmentDAO appointmentDAO;

    @Override
    public void init() throws ServletException {
        try {
            appointmentDAO = new AppointmentDAO();
        } catch (Exception e) {
            throw new ServletException("Failed to initialize AppointmentDAO", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {

            // =========================
            // SESSION CHECK (FIRST)
            // =========================
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("loggedInUser") == null) {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }

            // =========================
            // 1. APPOINTMENT LIST
            // =========================
            List<Appointment> appointmentList = appointmentDAO.getAllAppointments();
            request.setAttribute("appointmentList", appointmentList);

            // =========================
            // 2. STATS (OPTIMIZED - SINGLE QUERY)
            // =========================
            int[] stats = appointmentDAO.getAppointmentStats();

            request.setAttribute("totalAppointments", stats[0]);
            request.setAttribute("appointmentsToday", stats[1]);
            request.setAttribute("completedAppointments", stats[2]);

            // =========================
            // 3. FORWARD TO JSP
            // =========================
            request.getRequestDispatcher("/receptionists/appointments.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Error loading appointments", e);
        }
    }
}