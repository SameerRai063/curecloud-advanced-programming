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
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

public class ChatServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fragment = request.getParameter("fragment");
        if ("contacts".equalsIgnoreCase(fragment)) {
            try {
                renderContactsFragment(request, response);
            } catch (Exception e) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Unable to load contacts: " + e.getMessage());
                throw new ServletException("Unable to load contacts fragment", e);
            }
            return;
        }

        if ("messages".equalsIgnoreCase(fragment)) {
            try {
                renderMessagesFragment(request, response);
            } catch (Exception e) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Unable to load messages: " + e.getMessage());
                throw new ServletException("Unable to load messages fragment", e);
            }
            return;
        }

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int senderId = (Integer) session.getAttribute("userId");
        String role = String.valueOf(session.getAttribute("userRole"));
        String contactRole = "patient".equalsIgnoreCase(role) ? "receptionist" : "patient";

        try (Connection conn = DBConnection.getConnection()) {
            List<Contact> contacts = loadContacts(conn, contactRole);
            int receiverId = parseReceiverId(request.getParameter("receiverId"), contacts);
            String receiverName = findContactName(contacts, receiverId);

            request.setAttribute("senderId", senderId);
            request.setAttribute("receiverId", receiverId);
            request.setAttribute("receiverName", receiverName);
            request.setAttribute("contacts", contacts);
            request.setAttribute("contactRole", contactRole);
            request.getRequestDispatcher("/chat.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException("Unable to open chat", e);
        }
    }

    private void renderContactsFragment(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        int senderId = (Integer) session.getAttribute("userId");
        String role = String.valueOf(session.getAttribute("userRole"));
        String contactRole = "patient".equalsIgnoreCase(role) ? "receptionist" : "patient";
        int activeReceiverId = parseIntOrDefault(request.getParameter("receiverId"), 0);

        response.setContentType("text/html;charset=UTF-8");

        try (Connection conn = DBConnection.getConnection()) {
            List<ContactRow> contacts = loadContactRows(conn, role, contactRole, senderId, activeReceiverId);
            contacts.sort(Comparator
                    .comparing(ContactRow::hasUnread).reversed()
                    .thenComparing(ContactRow::getLastMessageAt, Comparator.nullsLast(Comparator.reverseOrder()))
                    .thenComparing(ContactRow::getUnreadCount, Comparator.reverseOrder())
                    .thenComparing(ContactRow::getName, String.CASE_INSENSITIVE_ORDER));

            StringBuilder sb = new StringBuilder();
            List<ContactRow> unreadContacts = new ArrayList<>();
            List<ContactRow> recentContacts = new ArrayList<>();
            for (ContactRow c : contacts) {
                if (c.getUnreadCount() > 0) {
                    unreadContacts.add(c);
                } else {
                    recentContacts.add(c);
                }
            }

            if (!unreadContacts.isEmpty()) {
                sb.append("<div class=\"mb-2 px-2 text-[11px] font-bold uppercase tracking-wide text-red-500\">Unread</div>");
                for (ContactRow contact : unreadContacts) {
                    appendContactRow(sb, request, contact);
                }
            }

            sb.append("<div class=\"mb-2 mt-3 px-2 text-[11px] font-bold uppercase tracking-wide text-slate-400\">Recent</div>");
            for (ContactRow contact : recentContacts) {
                appendContactRow(sb, request, contact);
            }

            if (contacts.isEmpty()) {
                sb.append("<div class=\"rounded-lg border border-dashed border-slate-300 bg-white p-4 text-sm text-slate-500\">No contacts found.</div>");
            }

            response.getWriter().print(sb.toString());
        }
    }

    private void renderMessagesFragment(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        String senderIdParam = request.getParameter("senderId");
        String receiverIdParam = request.getParameter("receiverId");
        if (senderIdParam == null || receiverIdParam == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing senderId or receiverId");
            return;
        }

        int senderId;
        int receiverId;
        try {
            senderId = Integer.parseInt(senderIdParam);
            receiverId = Integer.parseInt(receiverIdParam);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "senderId and receiverId must be integers");
            return;
        }

        if (!session.getAttribute("userId").equals(senderId)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Invalid sender");
            return;
        }

        response.setContentType("text/html;charset=UTF-8");

        try (Connection conn = DBConnection.getConnection()) {
            int patientId = resolvePatientId(conn, senderId, receiverId);
            boolean hasReceiverId = hasReceiverIdColumn(conn);

            if (hasReceiverId) {
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
                        "AND ((m.sender_id = ? AND m.receiver_id = ?) OR (m.sender_id = ? AND m.receiver_id = ?)) " +
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
        }
    }

    private List<Contact> loadContacts(Connection conn, String role) throws Exception {
        List<Contact> contacts = new ArrayList<>();
        String sql = contactSql(role);

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int contactId = rs.getInt("id");
                    String contactName = rs.getString("name");
                    contacts.add(new Contact(contactId, contactName));
                }
            }
        }

        return contacts;
    }

    private List<ContactRow> loadContactRows(Connection conn, String role, String contactRole, int senderId, int activeReceiverId) throws Exception {
        List<ContactRow> contacts = new ArrayList<>();
        String sql = contactSql(contactRole);

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int contactId = rs.getInt("id");
                    String contactName = rs.getString("name");
                    int patientId = "patient".equalsIgnoreCase(role) ? senderId : contactId;
                    contacts.add(loadContactRow(conn, patientId, senderId, contactId, contactName, activeReceiverId));
                }
            }
        }

        return contacts;
    }

    private String contactSql(String role) {
        if ("receptionist".equalsIgnoreCase(role)) {
            return "SELECT u.id, u.name FROM users u JOIN receptionist r ON r.user_id = u.id " +
                    "WHERE u.role = 'receptionist' ORDER BY u.name";
        }
        if ("patient".equalsIgnoreCase(role)) {
            return "SELECT u.id, u.name FROM users u JOIN patient p ON p.user_id = u.id " +
                    "WHERE u.role = 'patient' ORDER BY u.name";
        }
        return "SELECT id, name FROM users WHERE role = '' ORDER BY name";
    }

    private void appendContactRow(StringBuilder sb, HttpServletRequest request, ContactRow contact) {
        String itemClass = contact.isActive()
                ? "mb-2 flex items-center gap-3 rounded-lg px-3 py-3 text-sm font-semibold bg-[#0052FF] text-white"
                : contact.getUnreadCount() > 0
                ? "mb-2 flex items-center gap-3 rounded-lg px-3 py-3 text-sm font-semibold bg-blue-50 text-slate-900"
                : "mb-2 flex items-center gap-3 rounded-lg px-3 py-3 text-sm font-medium text-slate-700 hover:bg-white";

        String avatarClass = contact.isActive()
                ? "bg-white/20 text-white"
                : contact.getUnreadCount() > 0 ? "bg-blue-200 text-[#0052FF]" : "bg-slate-200 text-slate-700";

        sb.append("<div class=\"mb-3\">");
        // Build href using the application's context path so the link always points to the correct servlet
        String contactHref = request.getContextPath() + "/chat?receiverId=" + contact.getId();
        sb.append("<a class=\"" + itemClass + "\" href=\"" + contactHref + "\">");
        sb.append("<span class=\"flex size-9 items-center justify-center rounded-full ")
                .append(avatarClass)
                .append("\">")
                .append(contact.getInitial())
                .append("</span>");
        sb.append("<span class=\"flex-1\">")
                .append(escapeHtml(contact.getName()))
                .append("</span>");
        if (contact.getUnreadCount() > 0) {
            sb.append("<span class=\"ml-2 inline-flex h-2.5 w-2.5 rounded-full bg-red-500\" title=\"New message\"></span>");
            sb.append("<span class=\"ml-2 inline-flex items-center justify-center rounded-full bg-red-500 text-white text-xs px-2 py-1\">")
                    .append(contact.getUnreadCount())
                    .append("</span>");
        }
        sb.append("</a>");
        if (!contact.getLastMessagePreview().isEmpty()) {
            sb.append("<div class=\"ml-12 mt-1 text-[11px] text-slate-400 truncate\">")
                    .append(contact.getUnreadCount() > 0 ? "<span class=\"font-semibold text-red-500\">NEW:</span> " : "")
                    .append(escapeHtml(contact.getLastMessagePreview()))
                    .append("</div>");
        }
        sb.append("</div>");
    }

    private int parseReceiverId(String value, List<Contact> contacts) {
        if (value != null) {
            try {
                int receiverId = Integer.parseInt(value);
                for (Contact contact : contacts) {
                    if (contact.getId() == receiverId) {
                        return receiverId;
                    }
                }
            } catch (NumberFormatException ignored) {
                // Fall through to the first available contact.
            }
        }

        return contacts.isEmpty() ? 0 : contacts.get(0).getId();
    }

    private int parseIntOrDefault(String value, int defaultValue) {
        if (value == null || value.trim().isEmpty()) {
            return defaultValue;
        }
        try {
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    private String findContactName(List<Contact> contacts, int receiverId) {
        for (Contact contact : contacts) {
            if (contact.getId() == receiverId) {
                return contact.getName();
            }
        }
        return "No contact selected";
    }

    private ContactRow loadContactRow(Connection conn, int patientId, int senderId, int contactId, String contactName, int receiverId) throws Exception {
        boolean hasReceiverId = hasReceiverIdColumn(conn);
        int unread = 0;
        if (hasReceiverId) {
            String unreadSql = "SELECT COUNT(*) FROM conversations c JOIN messages m ON m.conversation_id = c.id " +
                    "WHERE c.patient_id = ? AND m.sender_id = ? AND (m.receiver_id = ? OR m.receiver_id IS NULL) AND m.is_read = 0";
            try (PreparedStatement ups = conn.prepareStatement(unreadSql)) {
                ups.setInt(1, patientId);
                ups.setInt(2, contactId);
                ups.setInt(3, senderId);
                try (ResultSet urs = ups.executeQuery()) {
                    if (urs.next()) unread = urs.getInt(1);
                }
            }
        } else {
            String unreadSql = "SELECT COUNT(*) FROM conversations c JOIN messages m ON m.conversation_id = c.id " +
                    "WHERE c.patient_id = ? AND m.sender_id = ? AND m.is_read = 0";
            try (PreparedStatement ups = conn.prepareStatement(unreadSql)) {
                ups.setInt(1, patientId);
                ups.setInt(2, contactId);
                try (ResultSet urs = ups.executeQuery()) {
                    if (urs.next()) unread = urs.getInt(1);
                }
            }
        }

        String preview = "";
        Timestamp lastMessageAt = null;
        if (hasReceiverId) {
            String lastMessageSql = "SELECT m.message_text, m.sent_at FROM messages m " +
                    "JOIN conversations c ON c.id = m.conversation_id " +
                    "WHERE c.patient_id = ? AND ((m.sender_id = ? AND m.receiver_id = ?) OR (m.sender_id = ? AND m.receiver_id = ?)) " +
                    "ORDER BY m.sent_at DESC, m.id DESC LIMIT 1";
            try (PreparedStatement lps = conn.prepareStatement(lastMessageSql)) {
                lps.setInt(1, patientId);
                lps.setInt(2, contactId);
                lps.setInt(3, senderId);
                lps.setInt(4, senderId);
                lps.setInt(5, contactId);
                try (ResultSet lrs = lps.executeQuery()) {
                    if (lrs.next()) {
                        preview = lrs.getString("message_text");
                        lastMessageAt = lrs.getTimestamp("sent_at");
                    }
                }
            }
        } else {
            String lastMessageSql = "SELECT m.message_text, m.sent_at FROM messages m " +
                    "JOIN conversations c ON c.id = m.conversation_id " +
                    "WHERE c.patient_id = ? AND (m.sender_id = ? OR m.sender_id = ?) " +
                    "ORDER BY m.sent_at DESC, m.id DESC LIMIT 1";
            try (PreparedStatement lps = conn.prepareStatement(lastMessageSql)) {
                lps.setInt(1, patientId);
                lps.setInt(2, contactId);
                lps.setInt(3, senderId);
                try (ResultSet lrs = lps.executeQuery()) {
                    if (lrs.next()) {
                        preview = lrs.getString("message_text");
                        lastMessageAt = lrs.getTimestamp("sent_at");
                    }
                }
            }
        }

        return new ContactRow(contactId, contactName, unread, preview, lastMessageAt, contactId == receiverId);
    }

    private boolean hasReceiverIdColumn(Connection conn) throws Exception {
        String sql = "SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS " +
                "WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'messages' AND COLUMN_NAME = 'receiver_id'";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next();
        }
    }

    // Resolve which user id is the patient for this conversation. One of the two participants must be a patient.
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

    private String escapeHtml(String s) {
        if (s == null) return "";
        return s.replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"","&quot;").replace("'","&#39;");
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

    private static class ContactRow {
        private final int id;
        private final String name;
        private final int unreadCount;
        private final String lastMessagePreview;
        private final Timestamp lastMessageAt;
        private final boolean active;

        private ContactRow(int id, String name, int unreadCount, String lastMessagePreview, Timestamp lastMessageAt, boolean active) {
            this.id = id;
            this.name = name == null ? "" : name;
            this.unreadCount = unreadCount;
            this.lastMessagePreview = lastMessagePreview == null ? "" : lastMessagePreview;
            this.lastMessageAt = lastMessageAt;
            this.active = active;
        }

        public int getId() { return id; }
        public String getName() { return name; }
        public int getUnreadCount() { return unreadCount; }
        public String getLastMessagePreview() { return lastMessagePreview; }
        public Timestamp getLastMessageAt() { return lastMessageAt; }
        public boolean isActive() { return active; }
        public boolean hasUnread() { return unreadCount > 0; }
        public String getInitial() { return name.trim().isEmpty() ? "?" : name.trim().substring(0, 1).toUpperCase(); }
    }

    public static class Contact {
        private final int id;
        private final String name;

        public Contact(int id, String name) {
            this.id = id;
            this.name = name;
        }

        public int getId() { return id; }
        public String getName() { return name; }
    }
}
