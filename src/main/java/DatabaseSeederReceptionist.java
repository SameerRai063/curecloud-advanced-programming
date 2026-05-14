import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import org.mindrot.jbcrypt.BCrypt;
import utils.DBConnection;

public class DatabaseSeederReceptionist {

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

            userPs.setString(1, "Receptionist A");
            userPs.setString(2, "Female");
            userPs.setDate(3, java.sql.Date.valueOf("1995-06-10"));
            userPs.setString(4, "Kathmandu, Nepal");
            userPs.setString(5, "9800000000");
            userPs.setString(6, "receptionist1@gmail.com");

            String hashedPassword = BCrypt.hashpw("123456", BCrypt.gensalt());
            userPs.setString(7, hashedPassword);

            userPs.setString(8, null);
            userPs.setString(9, "receptionist");

            userPs.executeUpdate();

            // Get generated user ID
            ResultSet rs = userPs.getGeneratedKeys();
            int userId = 0;

            if (rs.next()) {
                userId = rs.getInt(1);
            }

            // =========================
            // 2. INSERT INTO RECEPTIONIST
            // =========================
            String receptionistSql = "INSERT INTO receptionist " +
                    "(user_id, status) " +
                    "VALUES (?, ?)";

            PreparedStatement recPs = con.prepareStatement(receptionistSql);

            recPs.setInt(1, userId);
            recPs.setString(2, "active");

            recPs.executeUpdate();

            // Commit transaction
            con.commit();

            System.out.println("Receptionist user created successfully with ID: " + userId);

            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}