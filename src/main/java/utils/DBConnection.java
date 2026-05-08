package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    // Use the database name you have (updated to 'java_cw' per your environment)
    private static final String DB_URL = "jdbc:mysql://localhost:3306/java_cw";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "1234";


    public static Connection getConnection() throws SQLException, ClassNotFoundException {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(DB_URL,DB_USER,DB_PASSWORD);
    }
}
