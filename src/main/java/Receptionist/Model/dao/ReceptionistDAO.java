package Receptionist.Model.dao;

import Receptionist.Model.Receptionist;
import User.Model.User;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReceptionistDAO implements ReceptionistInterface {

    private Connection con;

    public ReceptionistDAO(Connection con) {
        this.con = con;
    }

    @Override
    public Receptionist getReceptionistById(int userId) throws Exception {
        String sql = "SELECT u.id, u.name, u.gender, u.dob, u.address, u.phone, u.email, " +
                "u.profile_image, u.role, u.created_at, u.updated_at, " +
                "r.status " +
                "FROM users u INNER JOIN receptionist r ON u.id = r.user_id " +
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

                    Receptionist receptionist = new Receptionist();
                    receptionist.setUserId(rs.getInt("id"));
                    receptionist.setStatus(rs.getString("status"));
                    receptionist.setUser(user);

                    return receptionist;
                }
            }
        }
        return null;
    }
@Override
public boolean addReceptionist(Receptionist receptionist) throws Exception {
    User user = receptionist.getUser();
    if (user == null) return false;

    String userQuery = "INSERT INTO users (name, gender, dob, address, phone, email, password, role, profile_image) VALUES (?, ?, ?, ?, ?, ?, ?, 'receptionist', ?)";
    String recQuery = "INSERT INTO receptionist (user_id, status) VALUES (?, ?)";

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
            userStmt.setString(7, user.getPassword());
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

        // 2. Insert into Receptionists Table
        try (PreparedStatement recStmt = con.prepareStatement(recQuery)) {
            recStmt.setInt(1, generatedUserId);
            recStmt.setString(2, receptionist.getStatus());

            recStmt.executeUpdate();
        }

        con.commit(); // Success: Commit both queries
        return true;

    } catch (Exception e) {
        con.rollback(); // Failure: Undo everything
        e.printStackTrace();
        throw e;
    } finally {
        con.setAutoCommit(originalAutoCommit);
    }
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
        // Delete from receptionist first (child), then users (parent) to respect FK constraint
        String deleteReceptionistSQL = "DELETE FROM receptionist WHERE user_id = ?";
        String deleteUserSQL         = "DELETE FROM users WHERE id = ?";

        boolean originalAutoCommit = con.getAutoCommit();

        try {
            con.setAutoCommit(false); // start transaction

            // Step 1: delete from receptionist table
            try (PreparedStatement psReceptionist = con.prepareStatement(deleteReceptionistSQL)) {
                psReceptionist.setInt(1, userId);
                int rows = psReceptionist.executeUpdate();
                if (rows == 0) {
                    con.rollback();
                    return false; // no receptionist found with that ID
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