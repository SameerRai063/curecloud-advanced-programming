package Notification.Controller;

import Notification.Model.dao.NotificationDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

public class NotificationCountServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Login required");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        response.setContentType("text/plain;charset=UTF-8");

        try {
            int unreadCount = new NotificationDAO().countUnreadForUser(userId);
            response.getWriter().print(unreadCount);
        } catch (Exception e) {
            throw new ServletException("Unable to load notification count", e);
        }
    }
}
