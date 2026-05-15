package Patient.Controller;

import Patient.Model.Patient;
import Patient.Model.dao.PatientDAO;
import User.Model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/patientProfile")
public class patientProfileServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private PatientDAO patientDAO;

    @Override
    public void init() {
        patientDAO = new PatientDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            User loggedInUser = (User) session.getAttribute("loggedInUser");
            int userId = loggedInUser.getId();

            Patient patient = patientDAO.getPatientById(userId);

            if (patient == null) {
                response.sendRedirect(
                        request.getContextPath() + "/patient/dashboard.jsp"); // ← fixed
                return;
            }

            request.setAttribute("patient", patient);
            request.getRequestDispatcher("/patient/settings.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(
                    request.getContextPath() + "/patient/dashboard.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}