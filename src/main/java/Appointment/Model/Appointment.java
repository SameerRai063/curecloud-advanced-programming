package Appointment.Model;

import java.sql.Date;
import java.sql.Timestamp;

public class Appointment {

    private int id;
    private int patientId;
    private String patientName;
    private int doctorId;
    private String doctorName; // <-- Added field
    private String department;
    private Date appointmentDate;
    private String reason;
    private String status; // scheduled, completed
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private java.sql.Time appointmentTime;
    // Constructor
    public Appointment() {}

    public Appointment(int patientId, int doctorId, String doctorName, String department,
                       Date appointmentDate, String reason, String status) {
        this.patientId = patientId;
        this.doctorId = doctorId;
        this.doctorName = doctorName; // <-- Added to constructor
        this.department = department;
        this.appointmentDate = appointmentDate;
        this.reason = reason;
        this.status = status;
    }

    // Getters and Setters

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getPatientId() { return patientId; }
    public void setPatientId(int patientId) { this.patientId = patientId; }

    public int getDoctorId() { return doctorId; }
    public void setDoctorId(int doctorId) { this.doctorId = doctorId; }

    // <-- Added Getter and Setter for doctorName -->
    public String getDoctorName() { return doctorName; }
    public void setDoctorName(String doctorName) { this.doctorName = doctorName; }

    public String getDepartment() { return department; }
    public void setDepartment(String department) { this.department = department; }

    public Date getAppointmentDate() { return appointmentDate; }
    public void setAppointmentDate(Date appointmentDate) { this.appointmentDate = appointmentDate; }

    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    public String getPatientName() { return patientName; }
    public void setPatientName(String patientName) { this.patientName = patientName; }
    public java.sql.Time getAppointmentTime() {
        return appointmentTime;
    }

    public void setAppointmentTime(java.sql.Time appointmentTime) {
        this.appointmentTime = appointmentTime;
    }
}