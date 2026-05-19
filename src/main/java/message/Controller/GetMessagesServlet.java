package message.Controller;

import utils.DBConnection;

import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class GetMessagesServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String senderIdParam = request.getParameter("senderId");
        String receiverIdParam = request.getParameter("receiverId");
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Login required");
            return;
        }

        if (senderIdParam == null || receiverIdParam == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                    "Missing senderId or receiverId");
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

        try (Connection conn = DBConnection.getConnection()) {

            int patientId = resolvePatientId(conn, senderId, receiverId);
            boolean hasReceiverId = hasReceiverIdColumn(conn);

            if (hasReceiverId) {
                // Mark incoming messages as read only for the active pair
                String markReadSql = "UPDATE messages m JOIN conversations c ON m.conversation_id = c.id " +
                        "SET m.is_read = 1 WHERE c.patient_id = ? AND m.sender_id = ? AND m.receiver_id = ? AND m.is_read = 0";
                try (PreparedStatement mr = conn.prepareStatement(markReadSql)) {
                    mr.setInt(1, patientId);
                    mr.setInt(2, receiverId);
                    mr.setInt(3, senderId);
                    mr.executeUpdate();
                }

                String sql = "SELECT m.sender_id, m.message_text " +
                        "FROM messages m " +
                        "JOIN conversations c ON c.id = m.conversation_id " +
                        "WHERE c.patient_id = ? " +
                        "AND ((m.sender_id = ? AND (m.receiver_id = ? OR m.receiver_id IS NULL)) " +
                        "OR (m.sender_id = ? AND (m.receiver_id = ? OR m.receiver_id IS NULL))) " +
                        "ORDER BY m.sent_at ASC";

                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, patientId);
                    ps.setInt(2, senderId);
                    ps.setInt(3, receiverId);
                    ps.setInt(4, receiverId);
                    ps.setInt(5, senderId);

                    writeMessages(response, ps, senderId);
                }
            } else {
                // Legacy fallback: no receiver_id column yet, keep old patient-centric behavior.
                String markReadSql = "UPDATE messages m JOIN conversations c ON m.conversation_id = c.id " +
                        "SET m.is_read = 1 WHERE c.patient_id = ? AND m.sender_id != ? AND m.is_read = 0";
                try (PreparedStatement mr = conn.prepareStatement(markReadSql)) {
                    mr.setInt(1, patientId);
                    mr.setInt(2, senderId);
                    mr.executeUpdate();
                }

                String sql = "SELECT m.sender_id, m.message_text " +
                        "FROM messages m " +
                        "JOIN conversations c ON c.id = m.conversation_id " +
                        "WHERE c.patient_id = ? ORDER BY m.sent_at ASC";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, patientId);
                    writeMessages(response, ps, senderId);
                }
            }

        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to load messages: " + e.getMessage());
            e.printStackTrace();
        }
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

    private void writeMessages(HttpServletResponse response, PreparedStatement ps, int senderId) throws Exception {
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                boolean ownMessage = rs.getInt("sender_id") == senderId;
                response.getWriter().println(
                        "<div class=\"flex " + (ownMessage ? "justify-end" : "justify-start") + "\">"
                                + "<div class=\"max-w-[70%] rounded-lg px-4 py-2 text-sm "
                                + (ownMessage ? "bg-[#0052FF] text-white" : "bg-white border border-slate-200 text-slate-800")
                                + "\">"
                                + escapeHtml(rs.getString("message_text"))
                                + "</div></div>");
            }
        }
    }

    private String escapeHtml(String value) {
        if (value == null) {
            return "";
        }

        return value
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
}
