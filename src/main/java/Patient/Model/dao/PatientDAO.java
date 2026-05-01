package Patient.Model.dao;

import Patient.Model.Patient;
import User.Model.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class PatientDAO implements PatientInterface {

    private Connection con;

    public PatientDAO(Connection con) {
        this.con = con;
    }

    @Override
    public boolean addPatient(Patient patient) throws Exception {

        String sql = "INSERT INTO patient(user_id, blood_group, is_active) VALUES (?, ?, ?)";

        PreparedStatement ps = con.prepareStatement(sql);

        ps.setInt(1, patient.getUserId());
        ps.setString(2, patient.getBloodGroup());
        ps.setString(3, patient.isActive() ? "yes" : "no");

        return ps.executeUpdate() > 0;
    }
    @Override
    public List<Patient> getAllPatients() throws Exception {

        List<Patient> patients = new ArrayList<>();

        // We select the necessary columns from both tables
        String sql = "SELECT u.id, u.name, u.gender, u.dob, u.address, u.phone, u.email, " +
                "u.profileImage, u.role, u.createdAt, u.updatedAt, " +
                "p.blood_group, p.is_active " +
                "FROM users u " +
                "INNER JOIN patient p ON u.id = p.user_id";

        PreparedStatement ps = con.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            // 1. Create and populate the User object
            User user = new User();
            user.setId(rs.getInt("id"));
            user.setName(rs.getString("name"));
            user.setGender(rs.getString("gender"));
            user.setDob(rs.getDate("dob"));
            user.setAddress(rs.getString("address"));
            user.setPhone(rs.getString("phone"));
            user.setEmail(rs.getString("email"));
            user.setProfileImage(rs.getString("profileImage"));
            user.setRole(rs.getString("role"));
            user.setCreatedAt(rs.getTimestamp("createdAt"));
            user.setUpdatedAt(rs.getTimestamp("updatedAt"));

            // 2. Create and populate the Patient object
            Patient patient = new Patient();
            patient.setUserId(rs.getInt("id"));
            patient.setBloodGroup(rs.getString("blood_group"));

            // Convert the string "yes"/"no" from DB to boolean
            boolean isActive = "yes".equalsIgnoreCase(rs.getString("is_active"));
            patient.setActive(isActive);

            // 3. Attach the User object to the Patient (Composition)
            patient.setUser(user);

            // 4. Add the fully constructed Patient to our list
            patients.add(patient);
        }

        return patients;
    }
    @Override
    public boolean deletePatient(int userId) throws Exception {
        String sql = "DELETE FROM patient WHERE user_id=?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, userId);
        return ps.executeUpdate() > 0;
    }
    @Override
    public boolean updatePatient(Patient patient) throws Exception {
        String sql = "UPDATE patient SET blood_group=?, is_active=? WHERE user_id=?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setString(1, patient.getBloodGroup());
        ps.setString(2, patient.isActive() ? "yes" : "no");
        ps.setInt(3, patient.getUserId());
        return ps.executeUpdate() > 0;
    }
}