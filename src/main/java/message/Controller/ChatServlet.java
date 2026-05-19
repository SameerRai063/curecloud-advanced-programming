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
import java.util.ArrayList;
import java.util.List;

public class ChatServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

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

    private List<Contact> loadContacts(Connection conn, String role) throws Exception {
        List<Contact> contacts = new ArrayList<>();
        String sql = "SELECT id, name FROM users WHERE role = ? ORDER BY name";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, role);
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

    private String findContactName(List<Contact> contacts, int receiverId) {
        for (Contact contact : contacts) {
            if (contact.getId() == receiverId) {
                return contact.getName();
            }
        }
        return "No contact selected";
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
