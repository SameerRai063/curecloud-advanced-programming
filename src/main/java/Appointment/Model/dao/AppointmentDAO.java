package Appointment.Model.dao;

import Appointment.Model.Appointment;
import utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AppointmentDAO implements AppointmentInterface {

    // =========================
    // MAP RESULTSET
    // =========================
    private Appointment mapResultSetToAppointment(ResultSet rs) throws SQLException {
        Appointment appointment = new Appointment();

        appointment.setId(rs.getInt("id"));
        appointment.setPatientId(rs.getInt("patient_id"));
        appointment.setDoctorId(rs.getInt("doctor_id"));

        appointment.setDoctorName(rs.getString("doctor_name"));
        appointment.setPatientName(rs.getString("patient_name")); // ✅ added
        appointment.setDepartment(rs.getString("department"));

        appointment.setAppointmentDate(rs.getDate("appointment_date"));
        appointment.setReason(rs.getString("reason"));
        appointment.setStatus(rs.getString("status"));

        appointment.setCreatedAt(rs.getTimestamp("created_at"));
        appointment.setUpdatedAt(rs.getTimestamp("updated_at"));

        return appointment;
    }

    // =========================
    // ADD APPOINTMENT
    // =========================
    @Override
    public int addAppointment(Appointment appointment) throws Exception {

        String sql = "INSERT INTO appointments " +
                "(patient_id, doctor_id, department, appointment_date,appointment_time, reason, status) " +
                "VALUES (?, ?, ?, ?, ?, ?,?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, appointment.getPatientId());
            ps.setInt(2, appointment.getDoctorId());
            ps.setString(3, appointment.getDepartment());
            ps.setDate(4, appointment.getAppointmentDate());
            ps.setTime(5, appointment.getAppointmentTime());
            ps.setString(6, appointment.getReason());
            ps.setString(7, appointment.getStatus());

            ps.executeUpdate();

            // Return the generated appointment id
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return -1;
    }

    // =========================
    // GET ALL APPOINTMENTS
    // =========================
    @Override
    public List<Appointment> getAllAppointments() throws Exception {

        List<Appointment> list = new ArrayList<>();

        String sql =
                "SELECT a.id, a.patient_id, a.doctor_id, " +
                        "pUser.name AS patient_name, " +
                        "dUser.name AS doctor_name, " +
                        "d.department, " +
                        "a.appointment_date, a.reason, a.status, " +
                        "a.created_at, a.updated_at " +
                        "FROM appointments a " +
                        "JOIN patient p ON a.patient_id = p.user_id " +
                        "JOIN users pUser ON p.user_id = pUser.id " +
                        "JOIN doctor d ON a.doctor_id = d.user_id " +
                        "JOIN users dUser ON d.user_id = dUser.id " +
                        "ORDER BY a.appointment_date DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapResultSetToAppointment(rs));
            }
        }

        return list;
    }

    // =========================
    // GET BY PATIENT ID
    // =========================
    @Override
    public List<Appointment> getAppointmentsByPatientId(int patientId) {

        List<Appointment> appointments = new ArrayList<>();

        String sql =
                "SELECT a.*, " +
                        "pUser.name AS patient_name, " +
                        "dUser.name AS doctor_name, " +
                        "d.department " +
                        "FROM appointments a " +
                        "JOIN patient p ON a.patient_id = p.user_id " +
                        "JOIN users pUser ON p.user_id = pUser.id " +
                        "JOIN doctor d ON a.doctor_id = d.user_id " +
                        "JOIN users dUser ON d.user_id = dUser.id " +
                        "WHERE a.patient_id = ? " +
                        "ORDER BY a.appointment_date DESC, a.appointment_time DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, patientId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {

                    Appointment ap = new Appointment();

                    ap.setId(rs.getInt("id"));
                    ap.setPatientId(rs.getInt("patient_id"));
                    ap.setDoctorId(rs.getInt("doctor_id"));

                    ap.setPatientName(rs.getString("patient_name"));
                    ap.setDoctorName(rs.getString("doctor_name"));

                    ap.setDepartment(rs.getString("department"));
                    ap.setAppointmentDate(rs.getDate("appointment_date"));

                    // ✅ NEW FIELD ADDED
                    ap.setAppointmentTime(rs.getTime("appointment_time"));

                    ap.setReason(rs.getString("reason"));
                    ap.setStatus(rs.getString("status"));
                    ap.setCreatedAt(rs.getTimestamp("created_at"));
                    ap.setUpdatedAt(rs.getTimestamp("updated_at"));

                    appointments.add(ap);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return appointments;
    }
    public int[] getAppointmentStats() throws Exception {

        String sql =
                "SELECT " +
                        "COUNT(*) AS total, " +
                        "SUM(DATE(appointment_date) = CURDATE()) AS today, " +
                        "SUM(status = 'completed') AS completed " +
                        "FROM appointments";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {

                int total = rs.getInt("total");
                int today = rs.getInt("today");
                int completed = rs.getInt("completed");

                return new int[]{total, today, completed};
            }
        }

        return new int[]{0, 0, 0};
    }
    // =========================
    // GET BY USER ID (PATIENT)
    // =========================

    @Override
    public List<Appointment> getAppointmentsByUserId(int userId) throws Exception {

        List<Appointment> list = new ArrayList<>();

        String sql =
                "SELECT a.*, " +
                        "pUser.name AS patient_name, " +
                        "dUser.name AS doctor_name, " +
                        "d.department " +
                        "FROM appointment a " +
                        "JOIN patient p ON a.patient_id = p.user_id " +
                        "JOIN users pUser ON p.user_id = pUser.id " +
                        "JOIN doctor d ON a.doctor_id = d.user_id " +
                        "JOIN users dUser ON d.user_id = dUser.id " +
                        "WHERE a.patient_id = ? " +
                        "ORDER BY a.appointment_date DESC, a.appointment_time DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToAppointment(rs));
                }
            }
        }

        return list;
    }

    // =========================
    // GET BY ID
    // =========================
    @Override
    public Appointment getAppointmentById(int appointmentId) {

        Appointment appointment = null;

        String sql =
                "SELECT a.*, " +
                        "pu.name AS patient_name, " +
                        "du.name AS doctor_name " +
                        "FROM appointments a " +
                        "JOIN users pu ON a.patient_id = pu.id " +
                        "JOIN users du ON a.doctor_id = du.id " +
                        "WHERE a.id = ?";

        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)
        ) {

            ps.setInt(1, appointmentId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                appointment = new Appointment();

                appointment.setId(rs.getInt("id"));
                appointment.setPatientId(rs.getInt("patient_id"));
                appointment.setPatientName(rs.getString("patient_name"));

                appointment.setDoctorId(rs.getInt("doctor_id"));
                appointment.setDoctorName(rs.getString("doctor_name"));

                appointment.setDepartment(rs.getString("department"));
                appointment.setAppointmentDate(rs.getDate("appointment_date"));

                appointment.setAppointmentTime(rs.getTime("appointment_time"));

                appointment.setReason(rs.getString("reason"));
                appointment.setStatus(rs.getString("status"));

                appointment.setCreatedAt(rs.getTimestamp("created_at"));
                appointment.setUpdatedAt(rs.getTimestamp("updated_at"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return appointment;
    }

    // =========================
    // DELETE
    // =========================
    @Override
    public boolean deleteAppointment(int appointmentId) {

        boolean rowDeleted = false;

        String sql = "DELETE FROM appointments WHERE id = ?";

        try (
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql)
        ) {

            ps.setInt(1, appointmentId);

            rowDeleted = ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return rowDeleted;
    }
    @Override
    public int getTotalAppointments() throws Exception {

        String sql = "SELECT COUNT(*) FROM appointments";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
    @Override
    public int getAppointmentsToday() throws Exception {

        String sql = "SELECT COUNT(*) FROM appointments WHERE DATE(appointment_date) = CURDATE()";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
    @Override
    public int getCompletedAppointments() throws Exception {

        String sql = "SELECT COUNT(*) FROM appointments WHERE status = 'completed'";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

}