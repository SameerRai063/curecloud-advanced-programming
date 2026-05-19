package Notification.Model;

import User.Model.User;
import java.sql.Timestamp;
import java.time.format.DateTimeFormatter;
import java.time.ZoneId;
import java.time.LocalDateTime;

public class Notification {

    private int id;

    private int userId;

    private String title;

    private String message;

    private boolean read;

    private Timestamp createdAt;

    // Relationship reference (managed manually by DAOs)
    private User user;

    // Constructors
    public Notification() {}

    public Notification(int userId, String title, String message) {
        this.userId = userId;
        this.title = title;
        this.message = message;
        this.read = false;
    }

    // Getters & Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public boolean isRead() { return read; }
    public void setRead(boolean read) { this.read = read; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }

    public String getFormattedDate() {
        if (createdAt == null) {
            return "";
        }
        // Convert through system default zone to avoid timezone-shifted display.
        LocalDateTime localDateTime = createdAt.toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime();
        return localDateTime.format(DateTimeFormatter.ofPattern("MMM d, yyyy h:mm:ss a"));
    }
}
