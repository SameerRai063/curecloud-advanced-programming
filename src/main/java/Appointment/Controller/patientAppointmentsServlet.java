package Appointment.Controller;

import Appointment.Model.dao.AppointmentDAO;
import Appointment.Model.Appointment;
import Doctor.Model.Doctor;
import Doctor.Model.dao.DoctorDAO;
import User.Model.User;
import utils.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
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

        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("loggedInUser");
        int patientId = user.getId();

        try (Connection con = DBConnection.getConnection()) {

            // Existing: fetch appointments
            List<Appointment> appointments = appointmentDAO.getAppointmentsByPatientId(patientId);
            request.setAttribute("appointments", appointments);

            // Added: fetch doctors for the booking form
            DoctorDAO doctorDAO = new DoctorDAO(con);
            List<Doctor> doctors = doctorDAO.getAllDoctors();
            request.setAttribute("doctorList", doctors);

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.getRequestDispatcher("/patient/history.jsp")
                .forward(request, response);
    }
}