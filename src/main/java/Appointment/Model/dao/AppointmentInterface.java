package Appointment.Model.dao;

import Appointment.Model.Appointment;
import java.util.List;

public interface AppointmentInterface {

    // Create
    boolean addAppointment(Appointment appointment) throws Exception;

    // Read
    List<Appointment> getAllAppointments() throws Exception;
    Appointment getAppointmentById(int id) throws Exception;
    List<Appointment> getAppointmentsByUserId(int userId) throws Exception;

    // Delete
    boolean deleteAppointment(int id) throws Exception;
}