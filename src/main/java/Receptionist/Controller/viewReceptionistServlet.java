package Receptionist.Controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;

import Receptionist.Model.Receptionist;
import Receptionist.Model.dao.ReceptionistDAO;
import utils.DBConnection;

@WebServlet("/receptionists")
public class viewReceptionistServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // 1. Get DB connection
            Connection con = DBConnection.getConnection();

            // 2. Create DAO
            ReceptionistDAO dao = new ReceptionistDAO(con);

            // 3. Fetch all data
            List<Receptionist> receptionistList = dao.getAllReceptionists();
            int total = dao.getTotalReceptionists();
            int active = dao.countActiveReceptionists();
            int onLeave = dao.countOnLeaveReceptionists();

            // 4. Set attributes
            request.setAttribute("receptionistList", receptionistList);
            request.setAttribute("totalReceptionists", total);
            request.setAttribute("activeReceptionists", active);
            request.setAttribute("onLeaveReceptionists", onLeave);

            // 5. Forward to JSP
            RequestDispatcher rd = request.getRequestDispatcher("/admin/receptionists.jsp");
            rd.forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}