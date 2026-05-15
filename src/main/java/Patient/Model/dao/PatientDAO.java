package Patient.Model.dao;

import Patient.Model.Patient;
import User.Model.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import org.mindrot.jbcrypt.BCrypt;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PatientDAO implements PatientInterface {

    private Connection con;

    public PatientDAO(Connection con) {
        this.con = con;
    }

    public boolean addPatient(Patient patient) throws Exception {
        User user = patient.getUser();
        if (user == null) return false;

        String userQuery = "INSERT INTO users (name, gender, dob, address, phone, email, password, role, profile_image) VALUES (?, ?, ?, ?, ?, ?, ?, 'patient', ?)";
        String patientQuery = "INSERT INTO patient (user_id, blood_group, is_active) VALUES (?, ?, ?)";

        boolean originalAutoCommit = con.getAutoCommit();

        try {
            con.setAutoCommit(false);

            int generatedUserId = -1;
            try (PreparedStatement userStmt = con.prepareStatement(userQuery, Statement.RETURN_GENERATED_KEYS)) {
                userStmt.setString(1, user.getName());
                userStmt.setString(2, user.getGender());
                userStmt.setDate(3, user.getDob());
                userStmt.setString(4, user.getAddress());
                userStmt.setString(5, user.getPhone());
                userStmt.setString(6, user.getEmail());
                String hashedPassword = BCrypt.hashpw(user.getPassword(), BCrypt.gensalt());

                userStmt.setString(7, hashedPassword);
                userStmt.setString(8, user.getProfileImage());

                int affectedRows = userStmt.executeUpdate();
                if (affectedRows == 0) throw new SQLException("Creating user failed, no rows affected.");

                try (ResultSet generatedKeys = userStmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        generatedUserId = generatedKeys.getInt(1);
                    } else {
                        throw new SQLException("Creating user failed, no ID obtained.");
                    }
                }
            }

            try (PreparedStatement patientStmt = con.prepareStatement(patientQuery)) {
                patientStmt.setInt(1, generatedUserId);
                patientStmt.setString(2, patient.getBloodGroup());
                patientStmt.setBoolean(3, patient.isActive());
                patientStmt.executeUpdate();
            }

            con.commit();
            return true;

        } catch (Exception e) {
            con.rollback();
            e.printStackTrace();
            throw e;
        } finally {
            con.setAutoCommit(originalAutoCommit);
        }
    }

    @Override
    public List<Patient> getAllPatients() throws Exception {
        List<Patient> patients = new ArrayList<>();
        String sql = "SELECT u.id, u.name, u.gender, u.dob, u.address, u.phone, u.email, " +
                "u.profile_image, u.role, u.created_at, u.updated_at, " +
                "p.blood_group, p.is_active " +
                "FROM users u " +
                "INNER JOIN patient p ON u.id = p.user_id";

        PreparedStatement ps = con.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            User user = new User();
            user.setId(rs.getInt("id"));
            user.setName(rs.getString("name"));
            user.setGender(rs.getString("gender"));
            user.setDob(rs.getDate("dob"));
            user.setAddress(rs.getString("address"));
            user.setPhone(rs.getString("phone"));
            user.setEmail(rs.getString("email"));
            user.setProfileImage(rs.getString("profile_image"));
            user.setRole(rs.getString("role"));
            user.setCreatedAt(rs.getTimestamp("created_at"));
            user.setUpdatedAt(rs.getTimestamp("updated_at"));

            Patient patient = new Patient();
            patient.setUserId(rs.getInt("id"));
            patient.setBloodGroup(rs.getString("blood_group"));
            boolean isActive = "yes".equalsIgnoreCase(rs.getString("is_active"));
            patient.setActive(isActive);
            patient.setUser(user);

            patients.add(patient);
        }
        return patients;
    }
    @Override
    public Patient getPatientById(int userId) throws Exception {
        String sql = "SELECT u.id, u.name, u.gender, u.dob, u.address, u.phone, u.email, " +
                "u.profile_image, u.role, u.created_at, u.updated_at, " +
                "p.blood_group, p.is_active " +
                "FROM users u INNER JOIN patient p ON u.id = p.user_id " +
                "WHERE u.id = ?";

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setId(rs.getInt("id"));
                    user.setName(rs.getString("name"));
                    user.setGender(rs.getString("gender"));
                    user.setDob(rs.getDate("dob"));
                    user.setAddress(rs.getString("address"));
                    user.setPhone(rs.getString("phone"));
                    user.setEmail(rs.getString("email"));
                    user.setProfileImage(rs.getString("profile_image"));
                    user.setRole(rs.getString("role"));
                    user.setCreatedAt(rs.getTimestamp("created_at"));
                    user.setUpdatedAt(rs.getTimestamp("updated_at"));

                    Patient patient = new Patient();
                    patient.setUserId(rs.getInt("id"));
                    patient.setBloodGroup(rs.getString("blood_group"));
                    patient.setActive("yes".equalsIgnoreCase(rs.getString("is_active")));
                    patient.setUser(user);

                    return patient;
                }
            }
        }
        return null;
    }
    @Override
    public boolean registerPatient(Patient patient) throws Exception {
        User user = patient.getUser();

        // Duplicate email check
        String checkSql = "SELECT 1 FROM users WHERE email = ?";
        try (PreparedStatement check = con.prepareStatement(checkSql)) {
            check.setString(1, user.getEmail());
            try (ResultSet rs = check.executeQuery()) {
                if (rs.next()) throw new IllegalArgumentException("An account with this email already exists.");
            }
        }

        con.setAutoCommit(false);

        try {
            // 1. Insert into users
            String insertUser =
                    "INSERT INTO users (name, gender, dob, address, phone, email, password, profile_image, role) " +
                            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

            int generatedUserId;

            try (PreparedStatement ps = con.prepareStatement(insertUser, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, user.getName());
                ps.setString(2, user.getGender());
                ps.setDate  (3, user.getDob());
                ps.setString(4, user.getAddress());
                ps.setString(5, user.getPhone());
                ps.setString(6, user.getEmail());
                String hashedPassword = BCrypt.hashpw(user.getPassword(), BCrypt.gensalt());

                ps.setString(7, hashedPassword);
                ps.setString(8, user.getProfileImage());
                ps.setString(9, user.getRole());
                ps.executeUpdate();

                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        generatedUserId = keys.getInt(1);
                    } else {
                        throw new SQLException("No generated key returned for users insert.");
                    }
                }
            }

            // 2. Insert into patient
            String insertPatient =
                    "INSERT INTO patient (user_id, blood_group, is_active) VALUES (?, ?, ?)";

            try (PreparedStatement ps = con.prepareStatement(insertPatient)) {
                ps.setInt   (1, generatedUserId);
                ps.setString(2, patient.getBloodGroup());
                ps.setString(3, patient.isActive() ? "yes" : "no");
                ps.executeUpdate();
            }

            con.commit();
            return true;

        } catch (Exception e) {
            con.rollback();
            throw e;
        } finally {
            con.setAutoCommit(true);
        }
    }
    @Override
    public boolean deletePatient(int userId) throws Exception {
        // Delete from patient first (child), then users (parent) to respect FK constraint
        String deletePatientSQL = "DELETE FROM patient WHERE user_id = ?";
        String deleteUserSQL    = "DELETE FROM users WHERE id = ?";

        boolean originalAutoCommit = con.getAutoCommit();

        try {
            con.setAutoCommit(false); // start transaction

            // Step 1: delete from patient table
            try (PreparedStatement psPatient = con.prepareStatement(deletePatientSQL)) {
                psPatient.setInt(1, userId);
                int rows = psPatient.executeUpdate();
                if (rows == 0) {
                    con.rollback();
                    return false; // no patient found with that ID
                }
            }

            // Step 2: delete from users table
            try (PreparedStatement psUser = con.prepareStatement(deleteUserSQL)) {
                psUser.setInt(1, userId);
                int rows = psUser.executeUpdate();
                if (rows == 0) {
                    con.rollback();
                    return false; // user row not found
                }
            }

            con.commit(); // both deletes succeeded
            return true;

        } catch (Exception e) {
            con.rollback();
            e.printStackTrace();
            throw e;
        } finally {
            con.setAutoCommit(originalAutoCommit);
        }
    }

    @Override
    public int getTotalPatients() throws Exception {
        String sql = "SELECT COUNT(*) FROM users WHERE role = 'patient'";
        try (PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    @Override
    public boolean updatePatientProfile(Patient patient, String currentPassword, String newPassword) throws Exception {
        if (patient.getUser() == null) {
            System.err.println("User object is missing from Patient.");
            return false;
        }

        String checkAuthQuery   = "SELECT password FROM users WHERE id = ?";
        String updateUserQuery  = "UPDATE users SET name = ?, email = ?, phone = ?, address = ?, password = ? WHERE id = ?";
        String updatePatientQuery = "UPDATE patient SET blood_group = ? WHERE user_id = ?";

        boolean originalAutoCommit = con.getAutoCommit();

        try {
            try (PreparedStatement checkStmt = con.prepareStatement(checkAuthQuery)) {
                checkStmt.setInt(1, patient.getUserId());
                try (ResultSet rs = checkStmt.executeQuery()) {
                    if (rs.next()) {
                        String dbPassword = rs.getString("password");
                        if (!dbPassword.equals(currentPassword)) {
                            System.err.println("Update Failed: Current password does not match.");
                            return false;
                        }
                    } else {
                        return false;
                    }
                }
            }

            con.setAutoCommit(false);

            String passwordToSave = (newPassword != null && !newPassword.trim().isEmpty())
                    ? newPassword
                    : currentPassword;

            try (PreparedStatement userStmt = con.prepareStatement(updateUserQuery)) {
                userStmt.setString(1, patient.getUser().getName());
                userStmt.setString(2, patient.getUser().getEmail());
                userStmt.setString(3, patient.getUser().getPhone());
                userStmt.setString(4, patient.getUser().getAddress());
                userStmt.setString(5, passwordToSave);
                userStmt.setInt(6, patient.getUserId());

                int userRowsAffected = userStmt.executeUpdate();
                if (userRowsAffected == 0) {
                    con.rollback();
                    return false;
                }
            }

            try (PreparedStatement patientStmt = con.prepareStatement(updatePatientQuery)) {
                patientStmt.setString(1, patient.getBloodGroup());
                patientStmt.setInt(2, patient.getUserId());

                int patientRowsAffected = patientStmt.executeUpdate();
                if (patientRowsAffected == 0) {
                    con.rollback();
                    return false;
                }
            }

            con.commit();
            return true;

        } catch (Exception e) {
            con.rollback();
            e.printStackTrace();
            throw e;
        } finally {
            con.setAutoCommit(originalAutoCommit);
        }
    }
}