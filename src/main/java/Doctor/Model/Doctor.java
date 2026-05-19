package Doctor.Model;

// ...existing code...
import User.Model.User;
import java.sql.Timestamp;

public class Doctor {

    // Department Constants
    public static final String CARDIOLOGY = "Cardiology";
    public static final String NEUROLOGY = "Neurology";
    public static final String PEDIATRICS = "Pediatrics";
    public static final String ORTHOPEDICS = "Orthopedics";
    public static final String GENERAL_MEDICINE = "General Medicine";

    private int userId;

    private String status;

    private String qualifications;

    private String department;

    private int experienceYears;

    private Timestamp createdAt;

    private Timestamp updatedAt;

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

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getQualifications() {
        return qualifications;
    }

    public void setQualifications(String qualifications) {
        this.qualifications = qualifications;
    }

    public String getDepartment() {
        return department;
    }

    public void setDepartment(String department) {
        if (department == null || department.trim().isEmpty()) {
            throw new IllegalArgumentException("Department is required.");
        }
        this.department = department.trim();
    }

    public int getExperienceYears() {
        return experienceYears;
    }

    public void setExperienceYears(int experienceYears) {
        this.experienceYears = experienceYears;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
        if (user != null) {
            this.userId = user.getId();
        }
    }
}
