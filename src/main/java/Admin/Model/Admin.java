package Admin.Model;

import User.Model.User;

import java.sql.Timestamp;

public class Admin {

    private int userId;
    private Timestamp lastLogin;

    // Optional link
    private User user;

    // Constructors
    public Admin() {}

    public Admin(int userId) {
        this.userId = userId;
    }

    public Admin(User user) {
        this.user = user;
        this.userId = user.getId();
    }

    // Getters & Setters

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public Timestamp getLastLogin() { return lastLogin; }
    public void setLastLogin(Timestamp lastLogin) { this.lastLogin = lastLogin; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }
}