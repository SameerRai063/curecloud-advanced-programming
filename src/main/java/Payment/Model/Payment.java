package Payment.Model;

import Appointment.Model.Appointment;
import Patient.Model.Patient;
import java.sql.Timestamp;
import java.math.BigDecimal;

public class Payment {

    private int id;

    private int patientId;

    private int appointmentId;

    private BigDecimal amount;

    private String paymentStatus; // pending, completed, failed

    private String paymentMethod;

    private Timestamp createdAt;

    private Timestamp updatedAt;

    // Relationships (managed manually by DAOs)
    private Patient patient;
    private Appointment appointment;

    // Constructors
    public Payment() {}

    public Payment(int patientId, int appointmentId, BigDecimal amount) {
        this.patientId = patientId;
        this.appointmentId = appointmentId;
        this.amount = amount;
        this.paymentStatus = "pending";
    }

    public Payment(int patientId, int appointmentId, BigDecimal amount, String paymentMethod) {
        this(patientId, appointmentId, amount);
        this.paymentMethod = paymentMethod;
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

    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    public Patient getPatient() { return patient; }
    public void setPatient(Patient patient) { this.patient = patient; }

    public Appointment getAppointment() { return appointment; }
    public void setAppointment(Appointment appointment) { this.appointment = appointment; }
}