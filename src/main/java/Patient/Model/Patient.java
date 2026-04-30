package Patient.Model;

import User.Model.User;

public class Patient {

    private int userId;
    private String bloodGroup;
    private boolean isActive; // UPDATED

    // Optional: include User object
    private User user;

    // Constructors
    public Patient() {}

    public Patient(int userId, String bloodGroup, boolean isActive) {
        this.userId = userId;
        this.bloodGroup = bloodGroup;
        this.isActive = isActive;
    }

    public Patient(User user, String bloodGroup, boolean isActive) {
        this.user = user;
        this.userId = user.getId();
        this.bloodGroup = bloodGroup;
        this.isActive = isActive;
    }

    // Getters & Setters

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getBloodGroup() {
        return bloodGroup;
    }

    public void setBloodGroup(String bloodGroup) {
        this.bloodGroup = bloodGroup;
    }

    public boolean isActive() {   // standard naming for boolean
        return isActive;
    }

    public void setActive(boolean isActive) {
        this.isActive = isActive;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }
}