package Notification.Controller;

import Notification.Model.dao.NotificationDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

public class MarkAllNotificationsReadServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/notifications.jsp");
            return;
        }

        try {
            new NotificationDAO().markAllReadForUser(userId);
        } catch (Exception e) {
            throw new ServletException("Unable to mark notifications as read", e);
        }

        response.sendRedirect(request.getContextPath() + "/notifications.jsp");
    }
}

