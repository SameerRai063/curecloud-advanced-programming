package Feedback.Model;

import Patient.Model.Patient;
import java.sql.Timestamp;
import java.time.format.DateTimeFormatter;

public class Feedback {

    private int id;

    private int patientId;

    private String comment;

    private int rating;

    private Timestamp createdAt;

    private String patientName;

    private Patient patient;

    // Constructors
    public Feedback() {}

    public Feedback(int patientId, String comment, int rating) {
        this.patientId = patientId;
        this.comment = comment;
        this.rating = rating;
    }

    // Getters & Setters

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getPatientId() { return patientId; }
    public void setPatientId(int patientId) { this.patientId = patientId; }

    public String getComment() { return comment; }
    public void setComment(String comment) { this.comment = comment; }

    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Patient getPatient() { return patient; }
    public void setPatient(Patient patient) { this.patient = patient; }

    // Helper getter for JSP backward compatibility
    public String getPatientName() {
        if (patientName != null) return patientName;
        return patient != null && patient.getUser() != null ? patient.getUser().getName() : "";
    }

    public void setPatientName(String patientName) { this.patientName = patientName; }

    /** Used by JSP via ${review.date} — formats as "Oct 12, 2023" */
    public String getDate() {
        if (createdAt == null) return "";
        return createdAt.toLocalDateTime()
                .format(DateTimeFormatter.ofPattern("MMM d, yyyy"));
    }
}