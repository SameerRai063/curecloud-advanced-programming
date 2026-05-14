import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import org.mindrot.jbcrypt.BCrypt;
import utils.DBConnection;

public class DatabaseSeeder {

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

            userPs.setString(1, "Dr. Samir");
            userPs.setString(2, "Male");
            userPs.setDate(3, java.sql.Date.valueOf("1990-03-22"));
            userPs.setString(4, "Lalitpur, Nepal");
            userPs.setString(5, "9811111111");
            userPs.setString(6, "doctor1@gmail.com");

            // BCrypt password for testing ("123456")
            String hashedPassword = BCrypt.hashpw("123456", BCrypt.gensalt());
            userPs.setString(7, hashedPassword);

            userPs.setString(8, null);
            userPs.setString(9, "doctor");

            userPs.executeUpdate();

            // Get generated user ID
            ResultSet rs = userPs.getGeneratedKeys();
            int userId = 0;

            if (rs.next()) {
                userId = rs.getInt(1);
            }

            // =========================
            // 2. INSERT INTO DOCTOR
            // =========================
            String doctorSql = "INSERT INTO doctor " +
                    "(user_id, status, qualifications, department, experience_years) " +
                    "VALUES (?, ?, ?, ?, ?)";

            PreparedStatement docPs = con.prepareStatement(doctorSql);

            docPs.setInt(1, userId);
            docPs.setString(2, "on leave");
            docPs.setString(3, "MBBS, MD Cardiology");
            docPs.setString(4, "Cardiology");
            docPs.setInt(5, 8);

            docPs.executeUpdate();

            con.commit();

            System.out.println("Doctor user created successfully with ID: " + userId);

            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}