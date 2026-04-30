package Consultation.Model;

import java.sql.Timestamp;

public class Consultation {

    private int id;
    private int appointmentId;
    private int doctorId;
    private int patientId;

    private String clinicDiagnosis;
    private String medicineNames;
    private String dosage;
    private String duration;
    private String notes;
    private Timestamp createdAt;

    // Constructors
    public Consultation() {}

    public Consultation(int appointmentId, int doctorId, int patientId,
                        String clinicDiagnosis, String medicineNames,
                        String dosage, String duration, String notes) {

        this.appointmentId = appointmentId;
        this.doctorId = doctorId;
        this.patientId = patientId;
        this.clinicDiagnosis = clinicDiagnosis;
        this.medicineNames = medicineNames;
        this.dosage = dosage;
        this.duration = duration;
        this.notes = notes;
    }

    // Getters & Setters

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getAppointmentId() { return appointmentId; }
    public void setAppointmentId(int appointmentId) { this.appointmentId = appointmentId; }

    public int getDoctorId() { return doctorId; }
    public void setDoctorId(int doctorId) { this.doctorId = doctorId; }

    public int getPatientId() { return patientId; }
    public void setPatientId(int patientId) { this.patientId = patientId; }

    public String getClinicDiagnosis() { return clinicDiagnosis; }
    public void setClinicDiagnosis(String clinicDiagnosis) { this.clinicDiagnosis = clinicDiagnosis; }

    public String getMedicineNames() { return medicineNames; }
    public void setMedicineNames(String medicineNames) { this.medicineNames = medicineNames; }

    public String getDosage() { return dosage; }
    public void setDosage(String dosage) { this.dosage = dosage; }

    public String getDuration() { return duration; }
    public void setDuration(String duration) { this.duration = duration; }

    public String getNotes() { return notes; }
    public void setNotes(String notes) { this.notes = notes; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}