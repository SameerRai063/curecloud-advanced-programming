package Receptionist.Model.dao;

import Receptionist.Model.Receptionist;
import User.Model.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ReceptionistDAO implements ReceptionistInterface {

    private Connection con;

    public ReceptionistDAO(Connection con) {
        this.con = con;
    }

    @Override
    public boolean addReceptionist(Receptionist receptionist) throws Exception {
        String sql = "INSERT INTO receptionist(user_id, status) VALUES (?, ?)";

        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, receptionist.getUserId());
        ps.setString(2, receptionist.getStatus());

        return ps.executeUpdate() > 0;
    }

    @Override
    public List<Receptionist> getAllReceptionists() throws Exception {
        List<Receptionist> receptionists = new ArrayList<>();

        // SQL JOIN to fetch User details AND Receptionist details
        String sql = "SELECT u.id, u.name, u.gender, u.dob, u.address, u.phone, u.email, " +
                "u.profileImage, u.role, u.createdAt, u.updatedAt, " +
                "r.status " +
                "FROM users u " +
                "INNER JOIN receptionist r ON u.id = r.user_id";

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

            // 2. Build the Receptionist object
            Receptionist receptionist = new Receptionist();
            receptionist.setUserId(rs.getInt("id"));
            receptionist.setStatus(rs.getString("status"));

            // 3. Attach User to Receptionist (Composition)
            receptionist.setUser(user);

            // 4. Add to list
            receptionists.add(receptionist);
        }

        return receptionists;
    }
    @Override
    public boolean deleteReceptionist(int userId) throws Exception {
        String sql = "DELETE FROM receptionist WHERE user_id=?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, userId);
        return ps.executeUpdate() > 0;
    }
}