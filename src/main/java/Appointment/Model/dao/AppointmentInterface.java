package Appointment.Model.dao;

import Appointment.Model.Appointment;
import java.util.List;

public interface AppointmentInterface {

    // Create
    public int addAppointment(Appointment appointment) throws Exception;

    // Read
    List<Appointment> getAllAppointments() throws Exception;
    Appointment getAppointmentById(int id) throws Exception;
    List<Appointment> getAppointmentsByUserId(int userId) throws Exception;
    public List<Appointment> getAppointmentsByPatientId(int patientId);
    // Delete
    boolean deleteAppointment(int id) throws Exception;
    public int getCompletedAppointments() throws Exception;
    public int getAppointmentsToday() throws Exception;
    public int getTotalAppointments() throws Exception;
}