package Receptionist.Model;

import User.Model.User;
import java.sql.Timestamp;

public class Receptionist {

    private int userId;

    private String status;

    private Timestamp createdAt;

    private Timestamp updatedAt;

    private User user;

    // Constructors
    public Receptionist() {}

    public Receptionist(int userId, String status) {
        this.userId = userId;
        this.status = status;
    }

    public Receptionist(User user, String status) {
        this.user = user;
        this.userId = user.getId();
        this.status = status;
    }

    // Getters & Setters

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    public User getUser() { return user; }

    public void setUser(User user) {
        this.user = user;
        if (user != null) {
            this.userId = user.getId();
        }
    }
}