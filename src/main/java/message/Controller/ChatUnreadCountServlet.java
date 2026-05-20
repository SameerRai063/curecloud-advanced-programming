package message.Controller;

import utils.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class ChatUnreadCountServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Login required");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");
        response.setContentType("text/plain;charset=UTF-8");

        try (Connection conn = DBConnection.getConnection()) {
            response.getWriter().print(countUnreadMessages(conn, userId));
        } catch (Exception e) {
            throw new ServletException("Unable to load chat unread count", e);
        }
    }

    private int countUnreadMessages(Connection conn, int userId) throws Exception {
        String sql = "SELECT COUNT(*) FROM messages m " +
                "JOIN conversations c ON c.id = m.conversation_id " +
                "WHERE m.is_read = 0 AND m.sender_id <> ? " +
                "AND (m.receiver_id = ? " +
                "OR (m.receiver_id IS NULL AND (c.patient_id = ? OR m.sender_id = c.patient_id)))";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, userId);
            ps.setInt(3, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }
}
