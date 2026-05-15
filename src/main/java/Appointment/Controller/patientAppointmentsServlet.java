package Appointment.Controller;

import Appointment.Model.dao.AppointmentDAO;
import Appointment.Model.Appointment;
import User.Model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/patientAppointments")
public class patientAppointmentsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private AppointmentDAO appointmentDAO;

    @Override
    public void init() {
        appointmentDAO = new AppointmentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Check if user is logged in
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Get logged-in user
        User user = (User) session.getAttribute("loggedInUser");

        int patientId = user.getId();

        // Fetch appointments
        List<Appointment> appointments =
                appointmentDAO.getAppointmentsByPatientId(patientId);

        // Send data to JSP
        request.setAttribute("appointments", appointments);

        // Forward to JSP page
        request.getRequestDispatcher("/patient/history.jsp")
                .forward(request, response);
    }
}