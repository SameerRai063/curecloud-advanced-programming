package Doctor.Model;

import User.Model.User;

public class Doctor {

    private int userId;
    private String status;
    private String qualifications;
    private String department;
    private int experienceYears;

    // Optional: link with User
    private User user;

    // Constructors
    public Doctor() {}

    public Doctor(int userId, String status, String qualifications,
                  String department, int experienceYears) {
        this.userId = userId;
        this.status = status;
        this.qualifications = qualifications;
        this.department = department;
        this.experienceYears = experienceYears;
    }

    public Doctor(User user, String status, String qualifications,
                  String department, int experienceYears) {
        this.user = user;
        this.userId = user.getId();
        this.status = status;
        this.qualifications = qualifications;
        this.department = department;
        this.experienceYears = experienceYears;
    }

    // Getters & Setters

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getQualifications() { return qualifications; }
    public void setQualifications(String qualifications) { this.qualifications = qualifications; }

    public String getDepartment() { return department; }
    public void setDepartment(String department) { this.department = department; }

    public int getExperienceYears() { return experienceYears; }
    public void setExperienceYears(int experienceYears) { this.experienceYears = experienceYears; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }
}