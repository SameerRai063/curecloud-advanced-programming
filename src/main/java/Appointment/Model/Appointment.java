package Appointment.Model;

import Doctor.Model.Doctor;
import Patient.Model.Patient;
import java.sql.Date;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;

public class Appointment {

    private int id;

    private int patientId;

    private int doctorId;

    private Date appointmentDate;

    private java.sql.Time appointmentTime;

    private String reason;

    private String status; // scheduled, completed, cancelled

    private Timestamp createdAt;

    private Timestamp updatedAt;

    private String patientName;

    private String doctorName;

    private String department;

    private Patient patient;

    private Doctor doctor;

    // Constructor
    public Appointment() {}

    public Appointment(int patientId, int doctorId, Date appointmentDate,
                       String reason, String status) {
        this.patientId = patientId;
        this.doctorId = doctorId;
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

    public Date getAppointmentDate() { return appointmentDate; }
    public void setAppointmentDate(Date appointmentDate) { this.appointmentDate = appointmentDate; }

    public java.sql.Time getAppointmentTime() { return appointmentTime; }
    public void setAppointmentTime(java.sql.Time appointmentTime) { this.appointmentTime = appointmentTime; }

    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    // Relationship getters
    public Patient getPatient() { return patient; }
    public void setPatient(Patient patient) { this.patient = patient; }

    public Doctor getDoctor() { return doctor; }
    public void setDoctor(Doctor doctor) { this.doctor = doctor; }

    public String getFormattedAppointmentTime() {
        if (appointmentTime == null) {
            return "";
        }
        return new SimpleDateFormat("h:mm a").format(appointmentTime);
    }

    // Transient field getters and setters (for display purposes)
    public String getPatientName() { return patientName; }
    public void setPatientName(String patientName) { this.patientName = patientName; }

    public String getDoctorName() { return doctorName; }
    public void setDoctorName(String doctorName) { this.doctorName = doctorName; }

    public String getDepartment() { return department; }
    public void setDepartment(String department) { this.department = department; }
}
