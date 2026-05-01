package Doctor.Controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;

import utils.DBConnection;
import Doctor.Model.Doctor;
import Doctor.Model.dao.DoctorDAO;

@WebServlet("/view-doctors")
public class viewDoctorsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Connection con = null;

        try {
            con = DBConnection.getConnection();
            DoctorDAO doctorDAO = new DoctorDAO(con);

            // 1. Fetch the list of all doctors from the database
            List<Doctor> doctorList = doctorDAO.getAllDoctors();

            // 2. Attach the list to the request object
            request.setAttribute("doctors", doctorList);

            // 3. Forward the request to your JSP page
            RequestDispatcher dispatcher = request.getRequestDispatcher("doctor_list.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            // Redirect to an error page or admin dashboard if something goes wrong
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