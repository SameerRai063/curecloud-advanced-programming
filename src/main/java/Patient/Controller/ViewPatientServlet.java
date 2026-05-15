package Patient.Controller;

import Patient.Model.Patient;
import Patient.Model.dao.PatientDAO;
import utils.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;

@WebServlet("/viewPatient")
public class ViewPatientServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");

        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/patients?error=missing_id");
            return;
        }

        int userId;
        try {
            userId = Integer.parseInt(idParam.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/patients?error=invalid_id");
            return;
        }

        try (Connection con = DBConnection.getConnection()) {
            PatientDAO patientDAO = new PatientDAO(con);
            Patient patient = patientDAO.getPatientById(userId);

            if (patient == null) {
                response.sendRedirect(request.getContextPath() + "/patients?error=not_found");
                return;
            }

            request.setAttribute("patient", patient);
            request.getRequestDispatcher("/viewPatient.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/patients?error=load_failed");
        }
    }
}