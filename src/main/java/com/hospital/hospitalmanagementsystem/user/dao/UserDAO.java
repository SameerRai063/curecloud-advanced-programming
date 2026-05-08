package com.hospital.hospitalmanagementsystem.user.dao;

import com.hospital.hospitalmanagementsystem.rating.util.DBConnection;
import com.hospital.hospitalmanagementsystem.user.model.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDAO implements UserInterface {

    @Override
    public User findByUsernameAndPassword(String username, String password) {
        String sql = "SELECT id, username, role, first_name, last_name FROM users WHERE username = ? AND password = SHA2(?,256) LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User u = new User();
                    u.setId(rs.getInt("id"));
                    u.setUsername(rs.getString("username"));
                    String role = rs.getString("role");
                    if (role != null) role = role.toUpperCase();
                    u.setRole(role);
                    u.setFirstName(rs.getString("first_name"));
                    u.setLastName(rs.getString("last_name"));
                    return u;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}

