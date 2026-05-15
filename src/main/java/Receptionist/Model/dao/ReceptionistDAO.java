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
public boolean addReceptionist(Receptionist receptionist) throws Exception{
    String sql = "DELETE FROM receptionist WHERE user_id=?";
    PreparedStatement ps = con.prepareStatement(sql);
    ps.setInt(1, receptionist.getUserId());
    return ps.executeUpdate() > 0;
}
    @Override
    public List<Receptionist> getAllReceptionists() throws Exception {
        List<Receptionist> receptionists = new ArrayList<>();

        // SQL JOIN to fetch User details AND Receptionist details
        String sql = "SELECT u.id, u.name, u.gender, u.dob, u.address, u.phone, u.email, " +
                "u.profile_image, u.role, u.created_at, u.updated_at, " +
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
            user.setProfileImage(rs.getString("profile_image"));
            user.setRole(rs.getString("role"));
            user.setCreatedAt(rs.getTimestamp("created_at"));
            user.setUpdatedAt(rs.getTimestamp("updated_at"));

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
    @Override
    public boolean updateReceptionistProfile(Receptionist receptionist, String currentPassword, String newPassword) throws Exception {
        if (receptionist.getUser() == null) {
            System.err.println("User object is missing from Receptionist.");
            return false;
        }

        String checkAuthQuery = "SELECT password FROM users WHERE id = ?";
        // Added profile_image to the query
        String updateUserQuery = "UPDATE users SET name = ?, email = ?, phone = ?, address = ?, password = ?, profile_image = ? WHERE id = ?";
        String updateReceptionistQuery = "UPDATE receptionist SET status = ? WHERE user_id = ?";

        boolean originalAutoCommit = con.getAutoCommit();

        try {
            // 1. Verify Current Password
            try (PreparedStatement checkStmt = con.prepareStatement(checkAuthQuery)) {
                checkStmt.setInt(1, receptionist.getUserId());
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

            // 2. Begin Transaction
            con.setAutoCommit(false);

            String passwordToSave = (newPassword != null && !newPassword.trim().isEmpty())
                    ? newPassword
                    : currentPassword;

            // 3. Update 'users' table
            try (PreparedStatement userStmt = con.prepareStatement(updateUserQuery)) {
                userStmt.setString(1, receptionist.getUser().getName());
                userStmt.setString(2, receptionist.getUser().getEmail());
                userStmt.setString(3, receptionist.getUser().getPhone());
                userStmt.setString(4, receptionist.getUser().getAddress());
                userStmt.setString(5, passwordToSave);
                userStmt.setString(6, receptionist.getUser().getProfileImage()); // Injecting the image filename
                userStmt.setInt(7, receptionist.getUserId());

                int userRowsAffected = userStmt.executeUpdate();
                if (userRowsAffected == 0) {
                    con.rollback();
                    return false;
                }
            }

            // 4. Update 'receptionist' table
            try (PreparedStatement repStmt = con.prepareStatement(updateReceptionistQuery)) {
                repStmt.setString(1, receptionist.getStatus());
                repStmt.setInt(2, receptionist.getUserId());

                int repRowsAffected = repStmt.executeUpdate();
                if (repRowsAffected == 0) {
                    con.rollback();
                    return false;
                }
            }

            // 5. Commit Transaction
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
    public int getTotalReceptionists() throws Exception {
        String sql = "SELECT COUNT(*) FROM users WHERE role = 'receptionist'";
        try (PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }
    @Override
    public int countActiveReceptionists() {

        int count = 0;

        String sql = "SELECT COUNT(*) FROM receptionist WHERE status = ?";

        try {

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, "active");

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                count = rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return count;
    }
    @Override
    public int countOnLeaveReceptionists() {

        int count = 0;

        String sql = "SELECT COUNT(*) FROM receptionist WHERE status = ?";

        try {

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, "on leave");

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                count = rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return count;
    }
}