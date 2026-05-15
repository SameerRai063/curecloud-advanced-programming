package Appointment.Model.dao;

import Appointment.Model.Appointment;
import utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AppointmentDAO implements AppointmentInterface {

    // Helper method to map the ResultSet to the Appointment object
    private Appointment mapResultSetToAppointment(ResultSet rs) throws SQLException {
        Appointment appointment = new Appointment();
        appointment.setId(rs.getInt("id"));
        appointment.setPatientId(rs.getInt("patient_id"));
        appointment.setDoctorId(rs.getInt("doctor_id"));
        appointment.setDoctorName(rs.getString("doctor_name")); // From the JOIN
        appointment.setDepartment(rs.getString("department"));
        appointment.setAppointmentDate(rs.getDate("appointment_date"));
        appointment.setReason(rs.getString("reason"));
        appointment.setStatus(rs.getString("status"));
        appointment.setCreatedAt(rs.getTimestamp("created_at"));
        appointment.setUpdatedAt(rs.getTimestamp("updated_at"));
        return appointment;
    }

    @Override
    public boolean addAppointment(Appointment appointment) throws Exception {
        String query = "INSERT INTO appointments (patient_id, doctor_id, department, appointment_date, reason, status) " +
                "VALUES (?, ?, ?, ?, ?, ?)";

        // Try-with-resources will automatically close the connection and statement
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, appointment.getPatientId());
            pstmt.setInt(2, appointment.getDoctorId());
            pstmt.setString(3, appointment.getDepartment());
            pstmt.setDate(4, appointment.getAppointmentDate());
            pstmt.setString(5, appointment.getReason());
            pstmt.setString(6, appointment.getStatus());

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        }
    }

    @Override
    public List<Appointment> getAllAppointments() throws Exception {
        List<Appointment> appointmentList = new ArrayList<>();
        String query = "SELECT a.*, d.name AS doctor_name " +
                "FROM appointments a " +
                "JOIN doctors d ON a.doctor_id = d.id " +
                "ORDER BY a.appointment_date DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                appointmentList.add(mapResultSetToAppointment(rs));
            }
        }
        return appointmentList;
    }

    @Override
    public Appointment getAppointmentById(int id) throws Exception {
        Appointment appointment = null;
        String query = "SELECT a.*, d.name AS doctor_name " +
                "FROM appointments a " +
                "JOIN doctors d ON a.doctor_id = d.id " +
                "WHERE a.id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, id);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    appointment = mapResultSetToAppointment(rs);
                }
            }
        }
        return appointment;
    }

    @Override
    public List<Appointment> getAppointmentsByUserId(int userId) throws Exception {
        List<Appointment> appointmentList = new ArrayList<>();
        // Query filters by patient_id to match the logged-in user
        String query = "SELECT a.*, d.name AS doctor_name " +
                "FROM appointments a " +
                "JOIN doctors d ON a.doctor_id = d.id " +
                "WHERE a.patient_id = ? " +
                "ORDER BY a.appointment_date DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, userId);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    appointmentList.add(mapResultSetToAppointment(rs));
                }
            }
        }
        return appointmentList;
    }

    @Override
    public boolean deleteAppointment(int id) throws Exception {
        String query = "DELETE FROM appointments WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, id);
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        }
    }
}