package Receptionist.Controller;

import Receptionist.Model.Receptionist;
import Receptionist.Model.dao.ReceptionistDAO;
import utils.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;

@WebServlet("/viewReceptionist")
public class viewReceptionistsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");

        // 🔹 Validate ID
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/receptionists?error=missing_id");
            return;
        }

        int userId;
        try {
            userId = Integer.parseInt(idParam.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/receptionists?error=invalid_id");
            return;
        }

        // 🔹 Database operation
        try (Connection con = DBConnection.getConnection()) {

            ReceptionistDAO receptionistDAO = new ReceptionistDAO(con);
            Receptionist receptionist = receptionistDAO.getReceptionistById(userId);

            // 🔹 Check if found
            if (receptionist == null) {
                response.sendRedirect(request.getContextPath() + "/receptionists?error=not_found");
                return;
            }

            // 🔹 Send to JSP
            request.setAttribute("receptionist", receptionist);
            request.getRequestDispatcher("/viewReceptionist.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/receptionists?error=load_failed");
        }
    }
}