package Conversation.Model;

import Patient.Model.Patient;

import java.sql.Timestamp;

public class Conversation {

    private int id;
    private int patientId;
    private Timestamp createdAt;

    // Optional: link Patient object
    private Patient patient;

    // Constructors
    public Conversation() {}

    public Conversation(int patientId) {
        this.patientId = patientId;
    }

    // Getters & Setters

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getPatientId() { return patientId; }
    public void setPatientId(int patientId) { this.patientId = patientId; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Patient getPatient() { return patient; }
    public void setPatient(Patient patient) { this.patient = patient; }
}