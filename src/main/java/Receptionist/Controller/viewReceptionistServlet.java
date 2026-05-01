package Receptionist.Controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;

import utils.DBConnection;
import Receptionist.Model.Receptionist;
import Receptionist.Model.dao.ReceptionistDAO;

@WebServlet("/view-receptionists")
public class viewReceptionistServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Connection con = null;

        try {
            con = DBConnection.getConnection();
            ReceptionistDAO receptionistDAO = new ReceptionistDAO(con);

            // 1. Fetch the list of all receptionists from the database
            List<Receptionist> receptionistList = receptionistDAO.getAllReceptionists();

            // 2. Attach the list to the request object
            request.setAttribute("receptionists", receptionistList);

            // 3. Forward the request to your JSP page
            RequestDispatcher dispatcher = request.getRequestDispatcher("receptionist_list.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
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