package Conversation.Model;

import Patient.Model.Patient;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class Conversation {

    private int id;

    private int patientId;

    private Timestamp createdAt;

    private Patient patient;

    private List<message.Model.Message> messages = new ArrayList<>();

    // Constructors
    public Conversation() {}

    public Conversation(int patientId) {
        this.patientId = patientId;
    }

    public Conversation(Patient patient) {
        this.patient = patient;
        this.patientId = patient.getUserId();
    }

    // Getters & Setters

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getPatientId() { return patientId; }
    public void setPatientId(int patientId) { this.patientId = patientId; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Patient getPatient() { return patient; }
    public void setPatient(Patient patient) {
        this.patient = patient;
        if (patient != null) {
            this.patientId = patient.getUserId();
        }
    }

    public List<message.Model.Message> getMessages() { return messages; }
    public void setMessages(List<message.Model.Message> messages) { this.messages = messages; }

    public void addMessage(message.Model.Message message) {
        if (messages == null) {
            messages = new ArrayList<>();
        }
        messages.add(message);
        message.setConversation(this);
    }
}