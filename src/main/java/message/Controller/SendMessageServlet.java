package message.Controller;

import Notification.Model.dao.NotificationDAO;
import utils.DBConnection;

import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

public class SendMessageServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/plain;charset=UTF-8");

        String senderIdParam = request.getParameter("senderId");
        String receiverIdParam = request.getParameter("receiverId");
        String message = request.getParameter("message");
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Login required");
            return;
        }

        if (senderIdParam == null || receiverIdParam == null || message == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                    "Missing senderId, receiverId, or message");
            return;
        }

        int senderId;
        int receiverId;

        try {
            senderId = Integer.parseInt(senderIdParam);
            receiverId = Integer.parseInt(receiverIdParam);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                    "senderId and receiverId must be integers");
            return;
        }

        if (!session.getAttribute("userId").equals(senderId)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid sender");
            return;
        }

        if (message.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                    "Message cannot be empty");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            int conversationId = findOrCreateConversation(conn, senderId, receiverId);

            if (hasReceiverIdColumn(conn)) {
                String sql = "INSERT INTO messages(conversation_id, sender_id, receiver_id, message_text) VALUES(?,?,?,?)";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, conversationId);
                    ps.setInt(2, senderId);
                    ps.setInt(3, receiverId);
                    ps.setString(4, message);
                    ps.executeUpdate();
                }
            } else {
                // Backward-compatibility for DBs that have not yet applied receiver_id migration.
                String sql = "INSERT INTO messages(conversation_id, sender_id, message_text) VALUES(?,?,?)";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, conversationId);
                    ps.setInt(2, senderId);
                    ps.setString(3, message);
                    ps.executeUpdate();
                }
            }

            // notify via notification table
            try {
                new NotificationDAO().addNotification(receiverId, "New Chat Message", "You received a new chat message.");
            } catch (Exception e) {
                e.printStackTrace();
            }

            response.getWriter().print("Message sent");

        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to store message: " + e.getMessage());
            e.printStackTrace();
        }
    }

    private int findOrCreateConversation(Connection conn, int senderId, int receiverId) throws Exception {
        int patientId = resolvePatientId(conn, senderId, receiverId);
        String findSql = "SELECT id FROM conversations WHERE patient_id = ? LIMIT 1";

        try (PreparedStatement ps = conn.prepareStatement(findSql)) {
            ps.setInt(1, patientId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("id");
                }
            }
        }

        String insertSql = "INSERT INTO conversations(patient_id) VALUES(?)";
        try (PreparedStatement ps = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, patientId);
            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }

        throw new IllegalStateException("Unable to create conversation");
    }

    private int resolvePatientId(Connection conn, int senderId, int receiverId) throws Exception {
        if (hasRole(conn, senderId, "patient")) {
            return senderId;
        }
        if (hasRole(conn, receiverId, "patient")) {
            return receiverId;
        }
        throw new IllegalArgumentException("A chat conversation must include a patient.");
    }

    private boolean hasRole(Connection conn, int userId, String role) throws Exception {
        String sql = "SELECT 1 FROM users WHERE id = ? AND role = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, role);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    private boolean hasReceiverIdColumn(Connection conn) throws Exception {
        String sql = "SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS " +
                "WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'messages' AND COLUMN_NAME = 'receiver_id'";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next();
        }
    }
}
