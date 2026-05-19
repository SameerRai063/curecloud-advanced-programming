package utils;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/**
 * Simple diagnostic servlet to verify DB connectivity and key tables (messages, notifications).
 * Map to /dbStatus in web.xml and visit it to see immediate DB errors.
 */
public class DBStatusServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/plain;charset=UTF-8");

        try (Connection conn = DBConnection.getConnection()) {
            resp.getWriter().println("DB Connection: OK");

            // Check messages table
            try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM messages")) {
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) resp.getWriter().println("messages.count=" + rs.getInt(1));
                }
            } catch (Exception e) {
                resp.getWriter().println("messages table: ERROR - " + e.getMessage());
            }

            // Check notifications table
            try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM notifications")) {
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) resp.getWriter().println("notifications.count=" + rs.getInt(1));
                }
            } catch (Exception e) {
                resp.getWriter().println("notifications table: ERROR - " + e.getMessage());
            }

        } catch (Exception e) {
            resp.getWriter().println("DB Connection: FAILED - " + e.getMessage());
            e.printStackTrace(resp.getWriter());
        }
    }
}

