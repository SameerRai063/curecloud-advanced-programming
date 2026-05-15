import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import org.mindrot.jbcrypt.BCrypt;
import utils.DBConnection;

public class DatabaseSeederAdmin {

    public static void main(String[] args) {

        try {
            Connection con = DBConnection.getConnection();
            con.setAutoCommit(false);

            // =========================
            // 1. INSERT INTO USERS
            // =========================
            String userSql = "INSERT INTO users " +
                    "(name, gender, dob, address, phone, email, password, profile_image, role) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

            PreparedStatement userPs = con.prepareStatement(userSql, PreparedStatement.RETURN_GENERATED_KEYS);

            userPs.setString(1, "Admin User");
            userPs.setString(2, "Male");
            userPs.setDate(3, java.sql.Date.valueOf("1990-01-01"));
            userPs.setString(4, "Kathmandu, Nepal");
            userPs.setString(5, "9811111111");
            userPs.setString(6, "admin@gmail.com");

            // ✅ bcrypt password
            String hashedPassword = BCrypt.hashpw("admin123", BCrypt.gensalt());
            userPs.setString(7, hashedPassword);

            userPs.setString(8, null);
            userPs.setString(9, "admin");

            userPs.executeUpdate();

            // Get generated user ID
            ResultSet rs = userPs.getGeneratedKeys();
            int userId = 0;

            if (rs.next()) {
                userId = rs.getInt(1);
            }

            // =========================
            // 2. INSERT INTO ADMIN
            // =========================
            String adminSql = "INSERT INTO admin " +
                    "(user_id, last_login) " +
                    "VALUES (?, ?)";

            PreparedStatement adminPs = con.prepareStatement(adminSql);

            adminPs.setInt(1, userId);
            adminPs.setTimestamp(2, null); // no login yet

            adminPs.executeUpdate();

            // Commit transaction
            con.commit();

            System.out.println("Admin user created successfully with ID: " + userId);

            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}