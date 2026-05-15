package Appointment.Controller;

import Appointment.Model.dao.AppointmentDAO;
import Appointment.Model.Appointment;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/viewAppointment")
public class AppointmentIDServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private AppointmentDAO appointmentDAO;

    @Override
    public void init() {
        appointmentDAO = new AppointmentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {

            int appointmentId = Integer.parseInt(request.getParameter("id"));

            Appointment appointment =
                    appointmentDAO.getAppointmentById(appointmentId);

            if (appointment == null) {
                response.sendRedirect(request.getContextPath() + "/appointments");
                return;
            }

            request.setAttribute("appointment", appointment);

            request.getRequestDispatcher("/Views/Admin/viewAppointment.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/appointments");
        }
    }
}