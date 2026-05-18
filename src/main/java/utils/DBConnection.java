package utils;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
    // Read connection info from environment variables for safety. If not set, fall back to defaults.
    private static final String DB_URL = System.getenv().getOrDefault("DB_URL", "jdbc:mysql://localhost:3306/curecloud");
    private static final String DB_USER = System.getenv().getOrDefault("DB_USER", "root");
    private static final String DB_PASSWORD = System.getenv().getOrDefault("DB_PASSWORD", "samirrai12345@");


    public static Connection getConnection() throws  Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(DB_URL,DB_USER,DB_PASSWORD);
    }
}
