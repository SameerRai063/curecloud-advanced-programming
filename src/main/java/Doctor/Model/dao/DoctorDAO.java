package Doctor.Model.dao;

import Doctor.Model.Doctor;
import User.Model.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class DoctorDAO implements DoctorInterface {

    private Connection con;

    public DoctorDAO(Connection con) {
        this.con = con;
    }

    @Override
    public boolean addDoctor(Doctor doctor) throws Exception {
        String sql = "INSERT INTO doctor(user_id, status, qualifications, department, experience_years) VALUES (?, ?, ?, ?, ?)";

        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, doctor.getUserId());
        ps.setString(2, doctor.getStatus());
        ps.setString(3, doctor.getQualifications());
        ps.setString(4, doctor.getDepartment());
        ps.setInt(5, doctor.getExperienceYears());

        return ps.executeUpdate() > 0;
    }

    @Override
    public List<Doctor> getAllDoctors() throws Exception {
        List<Doctor> doctors = new ArrayList<>();

        // SQL JOIN to fetch User details AND Doctor details
        String sql = "SELECT u.id, u.name, u.gender, u.dob, u.address, u.phone, u.email, " +
                "u.profileImage, u.role, u.createdAt, u.updatedAt, " +
                "d.status, d.qualifications, d.department, d.experience_years " +
                "FROM users u " +
                "INNER JOIN doctor d ON u.id = d.user_id";

        PreparedStatement ps = con.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();

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
            user.setProfileImage(rs.getString("profileImage"));
            user.setRole(rs.getString("role"));
            user.setCreatedAt(rs.getTimestamp("createdAt"));
            user.setUpdatedAt(rs.getTimestamp("updatedAt"));

            // 2. Build the Doctor object
            Doctor doctor = new Doctor();
            doctor.setUserId(rs.getInt("id"));
            doctor.setStatus(rs.getString("status"));
            doctor.setQualifications(rs.getString("qualifications"));
            doctor.setDepartment(rs.getString("department"));
            doctor.setExperienceYears(rs.getInt("experience_years"));

            // 3. Attach User to Doctor (Composition)
            doctor.setUser(user);

            // 4. Add to list
            doctors.add(doctor);
        }

        return doctors;
    }
    @Override
    public boolean deleteDoctor(int userId) throws Exception {
        String sql = "DELETE FROM doctor WHERE user_id=?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, userId);
        return ps.executeUpdate() > 0;
    }
}