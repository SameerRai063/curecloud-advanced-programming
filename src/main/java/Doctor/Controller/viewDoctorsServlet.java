package Doctor.Controller;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;
import java.util.Map;
import utils.DBConnection;
import Doctor.Model.Doctor;
import Doctor.Model.dao.DoctorDAO;

@WebServlet("/doctors")
public class viewDoctorsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Connection con = null;

        try {
            con = DBConnection.getConnection();
            DoctorDAO doctorDAO = new DoctorDAO(con);

            // 1. Get doctor list
            List<Doctor> doctorsList = doctorDAO.getAllDoctors();

            // 2. Get stats
            Map<String, Integer> stats = doctorDAO.getDoctorStats();

            // 3. Set attributes for JSP
            request.setAttribute("doctorsList",  doctorsList);
            request.setAttribute("totalDoctors", stats.get("total"));
            request.setAttribute("activeToday",  stats.get("active"));
            request.setAttribute("onLeave",      stats.get("onLeave"));

            // Debug logs — remove after confirming fix
            System.out.println("[viewDoctorsServlet] Doctors fetched: " + doctorsList.size());
            System.out.println("[viewDoctorsServlet] Total stat: "      + stats.get("total"));

            // 4. Forward to JSP
            RequestDispatcher rd = request.getRequestDispatcher("/admin/doctors.jsp");
            rd.forward(request, response);

        } catch (Exception e) {
            // FIX: Don't silently redirect — expose the real error message in the JSP
            e.printStackTrace();
            request.setAttribute("errorMessage", e.getMessage());
            request.setAttribute("errorClass",   e.getClass().getName());
            RequestDispatcher rd = request.getRequestDispatcher("/admin/doctors.jsp");
            rd.forward(request, response);

        } finally {
            try {
                if (con != null) con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
