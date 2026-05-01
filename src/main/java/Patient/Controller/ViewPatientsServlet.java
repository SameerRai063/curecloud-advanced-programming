package Patient.Controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;

import utils.DBConnection;
import Patient.Model.Patient;
import Patient.Model.dao.PatientDAO;

@WebServlet("/view-patients")
public class ViewPatientsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Connection con = null;

        try {
            con = DBConnection.getConnection();
            PatientDAO patientDAO = new PatientDAO(con);

            // 1. Fetch the list of all patients from the database
            List<Patient> patientList = patientDAO.getAllPatients();

            // 2. Attach the list to the request object so the JSP can access it
            request.setAttribute("patients", patientList);

            // 3. Forward the request to your JSP page (e.g., patient_list.jsp)
            RequestDispatcher dispatcher = request.getRequestDispatcher("patient_list.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            // Redirect to an error page or dashboard if something goes wrong
            response.sendRedirect("admin_dashboard.jsp?error=database_error");
        } finally {
            try {
                if (con != null) {
                    con.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}