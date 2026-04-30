package Receptionist.Model;

import User.Model.User;

public class Receptionist {

    private int userId;
    private String status;

    // Optional: link with User
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

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }
}