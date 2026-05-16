package Feedback.Model;

import java.sql.Timestamp;

public class Feedback {

    private int id;
    private int patientId;
    private String comment;
    private int rating;
    private Timestamp createdAt;
    private String patientName;
    // Constructors
    public Feedback() {}

    public Feedback( int patientId, String comment, int rating) {
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

    public String getPatientName() { return patientName; }
    public void setPatientName(String patientName) { this.patientName = patientName; }
}