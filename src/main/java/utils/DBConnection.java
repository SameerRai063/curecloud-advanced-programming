package utils;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
    // Read connection info from environment variables when available to avoid hard-coded secrets.
    // Defaults are set to sane local-development values (adjust as needed).
    private static final String DB_URL = System.getenv().getOrDefault(
            "CURECLOUD_DB_URL",
            "jdbc:mysql://127.0.0.1:3306/suraj?serverTimezone=UTC&useSSL=false&allowPublicKeyRetrieval=true"
    );
    private static final String DB_USER = System.getenv().getOrDefault("CURECLOUD_DB_USER", "root");
    private static final String DB_PASSWORD = System.getenv().getOrDefault("CURECLOUD_DB_PASSWORD", "samirrai12345@");


    public static Connection getConnection() throws  Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(DB_URL,DB_USER,DB_PASSWORD);
    }
}
