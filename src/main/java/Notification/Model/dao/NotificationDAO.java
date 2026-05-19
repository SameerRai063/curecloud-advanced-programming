package Notification.Model.dao;

import Notification.Model.Notification;
import utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class NotificationDAO {
    public void addNotification(int userId, String title, String message) throws Exception {
        String sql = "INSERT INTO notifications (user_id, title, message) VALUES (?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, title);
            ps.setString(3, message);
            ps.executeUpdate();
        }
    }

    public void addNotificationForRole(String role, String title, String message) throws Exception {
        String sql;
        if ("receptionist".equalsIgnoreCase(role)) {
            sql = "INSERT INTO notifications (user_id, title, message) " +
                    "SELECT u.id, ?, ? FROM users u JOIN receptionist r ON r.user_id = u.id WHERE u.role = ?";
        } else if ("patient".equalsIgnoreCase(role)) {
            sql = "INSERT INTO notifications (user_id, title, message) " +
                    "SELECT u.id, ?, ? FROM users u JOIN patient p ON p.user_id = u.id WHERE u.role = ?";
        } else {
            sql = "INSERT INTO notifications (user_id, title, message) " +
                    "SELECT id, ?, ? FROM users WHERE role = ?";
        }

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, title);
            ps.setString(2, message);
            ps.setString(3, role);
            ps.executeUpdate();
        }
    }

    public List<Notification> getNotificationsForUser(int userId) throws Exception {
        List<Notification> notifications = new ArrayList<>();
        String sql = "SELECT id, user_id, title, message, is_read, created_at " +
                "FROM notifications WHERE user_id = ? ORDER BY created_at DESC, id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Notification notification = new Notification();
                    notification.setId(rs.getInt("id"));
                    notification.setUserId(rs.getInt("user_id"));
                    notification.setTitle(rs.getString("title"));
                    notification.setMessage(rs.getString("message"));
                    notification.setRead(rs.getBoolean("is_read"));
                    notification.setCreatedAt(rs.getTimestamp("created_at"));
                    notifications.add(notification);
                }
            }
        }

        return notifications;
    }

    public int countUnreadForUser(int userId) throws Exception {
        String sql = "SELECT COUNT(*) FROM notifications WHERE user_id = ? AND is_read = 0";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    public int markAllReadForUser(int userId) throws Exception {
        String sql = "UPDATE notifications SET is_read = 1 WHERE user_id = ? AND is_read = 0";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate();
        }
    }
}
