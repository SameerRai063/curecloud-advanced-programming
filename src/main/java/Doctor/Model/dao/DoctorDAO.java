package Doctor.Model.dao;

import Doctor.Model.Doctor;
import User.Model.User;
import org.mindrot.jbcrypt.BCrypt;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DoctorDAO implements DoctorInterface {

    private Connection con;

    public DoctorDAO(Connection con) {
        this.con = con;
    }



    @Override
    public List<Doctor> getAllDoctors() throws Exception {
        List<Doctor> doctors = new ArrayList<>();

        // FIX: Changed INNER JOIN → LEFT JOIN so no doctor rows are silently dropped
        // FIX: Added WHERE u.role = 'doctor' to exclude non-doctor users
        String sql = "SELECT u.id, u.name, u.gender, u.dob, u.address, u.phone, u.email, " +
                "u.profile_image, u.role, u.created_at, u.updated_at, " +
                "d.status, d.qualifications, d.department, d.experience_years " +
                "FROM users u " +
                "LEFT JOIN doctor d ON u.id = d.user_id " +
                "WHERE u.role = 'doctor'";

        // FIX: try-with-resources ensures PreparedStatement and ResultSet are always closed
        try (PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                // 1. Build the User object
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

                // 2. Build the Doctor object
                Doctor doctor = new Doctor();
                doctor.setUserId(rs.getInt("id"));
                doctor.setStatus(rs.getString("status"));
                doctor.setQualifications(rs.getString("qualifications"));
                doctor.setDepartment(rs.getString("department"));
                doctor.setExperienceYears(rs.getInt("experience_years"));

                // 3. Attach User to Doctor
                doctor.setUser(user);

                // 4. Add to list
                doctors.add(doctor);
            }
        }

        return doctors;
    }

    @Override
    public boolean updateDoctor(Doctor doctor) throws Exception {
        String sql = "UPDATE doctor SET status=?, qualifications=?, department=?, experience_years=? WHERE user_id=?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, doctor.getStatus());
        ps.setString(2, doctor.getQualifications());
        ps.setString(3, doctor.getDepartment());
        ps.setInt(4, doctor.getExperienceYears());
        ps.setInt(5, doctor.getUserId());
        return ps.executeUpdate() > 0;
    }
    @Override
    public int getTotalDoctors() throws Exception {
        String sql = "SELECT COUNT(*) FROM doctor";
        try (PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }
    @Override
    public Map<String, Integer> getDoctorStats() throws Exception {
        Map<String, Integer> stats = new HashMap<>();

        String sql = "SELECT " +
                "COUNT(*) AS total, " +
                "SUM(CASE WHEN status = 'active' THEN 1 ELSE 0 END) AS activeCount, " +
                "SUM(CASE WHEN status = 'on leave' THEN 1 ELSE 0 END) AS onLeaveCount " +
                "FROM doctor";

        // FIX: try-with-resources ensures resources are always closed
        try (PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                stats.put("total",   rs.getInt("total"));
                // FIX: SUM() returns NULL on empty table; getInt() safely returns 0 for NULL,
                //      but we guard explicitly for clarity
                stats.put("active",  rs.getObject("activeCount")  != null ? rs.getInt("activeCount")  : 0);
                stats.put("onLeave", rs.getObject("onLeaveCount") != null ? rs.getInt("onLeaveCount") : 0);
            } else {
                // Fallback if no rows returned at all
                stats.put("total",   0);
                stats.put("active",  0);
                stats.put("onLeave", 0);
            }
        }

        return stats;
    }
    @Override
    public boolean addDoctor(Doctor doctor) throws Exception {
        User user = doctor.getUser();
        if (user == null) return false;

        String userQuery = "INSERT INTO users (name, gender, dob, address, phone, email, password, role, profile_image) VALUES (?, ?, ?, ?, ?, ?, ?, 'doctor', ?)";
        String doctorQuery = "INSERT INTO doctor (user_id, status, qualifications, department, experience_years) VALUES (?, ?, ?, ?, ?)";

        boolean originalAutoCommit = con.getAutoCommit();

        try {
            con.setAutoCommit(false); // Start Transaction

            // 1. Insert into Users Table
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

            // 2. Insert into Doctors Table
            try (PreparedStatement doctorStmt = con.prepareStatement(doctorQuery)) {
                doctorStmt.setInt(1, generatedUserId);
                doctorStmt.setString(2, doctor.getStatus());
                doctorStmt.setString(3, doctor.getQualifications());
                doctorStmt.setString(4, doctor.getDepartment());
                doctorStmt.setInt(5, doctor.getExperienceYears());

                doctorStmt.executeUpdate();
            }

            con.commit(); // Success
            return true;

        } catch (Exception e) {
            con.rollback(); // Undo everything if any part fails
            e.printStackTrace();
            throw e;
        } finally {
            con.setAutoCommit(originalAutoCommit);
        }
    }
    @Override
    public Doctor getDoctorById(int userId) throws Exception {
        String sql = "SELECT u.id, u.name, u.gender, u.dob, u.address, u.phone, u.email, " +
                "u.profile_image, u.role, u.created_at, u.updated_at, " +
                "d.status, d.qualifications, d.department, d.experience_years " +
                "FROM users u INNER JOIN doctor d ON u.id = d.user_id " +
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

                    Doctor doctor = new Doctor();
                    doctor.setUserId(rs.getInt("id"));
                    doctor.setStatus(rs.getString("status"));
                    doctor.setQualifications(rs.getString("qualifications"));
                    doctor.setDepartment(rs.getString("department"));
                    doctor.setExperienceYears(rs.getInt("experience_years"));
                    doctor.setUser(user);

                    return doctor;
                }
            }
        }
        return null;
    }

    @Override
    public boolean deleteDoctor(int userId) throws Exception {
        // Delete from doctor first (child), then users (parent) to respect FK constraint
        String deleteDoctorSQL = "DELETE FROM doctor WHERE user_id = ?";
        String deleteUserSQL   = "DELETE FROM users WHERE id = ?";

        boolean originalAutoCommit = con.getAutoCommit();

        try {
            con.setAutoCommit(false); // start transaction

            // Step 1: delete from doctor table
            try (PreparedStatement psDoctor = con.prepareStatement(deleteDoctorSQL)) {
                psDoctor.setInt(1, userId);
                int rows = psDoctor.executeUpdate();
                if (rows == 0) {
                    con.rollback();
                    return false; // no doctor found with that ID
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
            if (con != null) {
                con.rollback();
            }
            e.printStackTrace();
            throw e;
        } finally {
            if (con != null) {
                con.setAutoCommit(originalAutoCommit);
            }
        }
    }
}
