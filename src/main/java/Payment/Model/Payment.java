package Payment.Model;

import Patient.Model.Patient;

import java.sql.Timestamp;
import java.math.BigDecimal;

public class Payment {

    private int id;
    private int patientId;
    private int appointmentId;
    private BigDecimal amount;
    private Timestamp createdAt;

    // Optional links
    private Patient patient;

    // Constructors
    public Payment() {}

    public Payment(int patientId, int appointmentId, BigDecimal amount) {
        this.patientId = patientId;
        this.appointmentId = appointmentId;
        this.amount = amount;
    }

    // Getters & Setters

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getPatientId() { return patientId; }
    public void setPatientId(int patientId) { this.patientId = patientId; }

    public int getAppointmentId() { return appointmentId; }
    public void setAppointmentId(int appointmentId) { this.appointmentId = appointmentId; }

    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Patient getPatient() { return patient; }
    public void setPatient(Patient patient) { this.patient = patient; }
}