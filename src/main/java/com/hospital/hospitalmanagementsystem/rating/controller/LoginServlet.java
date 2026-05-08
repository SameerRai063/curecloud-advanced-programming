package com.hospital.hospitalmanagementsystem.rating.controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import utils.DBConnection;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        try {
            String username = request.getParameter("username");
            String password = request.getParameter("password");

            if (username == null || username.trim().isEmpty() ||
                password == null || password.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.println("{\"success\": false, \"message\": \"Username and password are required\"}");
                return;
            }

            // Check user credentials
            // Security: do NOT store/compare plain-text passwords.
            // This assumes `users.password` stores a SHA-256 hash (hex) created at signup.
            // If your schema uses `password_hash` instead, rename the column here.
            String sql = "SELECT id, role, first_name, last_name FROM users WHERE username = ? AND password = SHA2(?, 256)";

            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement pstmt = conn.prepareStatement(sql)) {

                pstmt.setString(1, username);
                pstmt.setString(2, password);

                try (ResultSet rs = pstmt.executeQuery()) {
                    if (rs.next()) {
                        int userId = rs.getInt("id");
                        String role = rs.getString("role");
                        if (role != null) role = role.toUpperCase();
                        String firstName = rs.getString("first_name");
                        String lastName = rs.getString("last_name");

                        // Create session
                        HttpSession session = request.getSession();
                        session.setAttribute("userId", userId);
                        session.setAttribute("username", username);
                        session.setAttribute("role", role);
                        session.setAttribute("firstName", firstName);
                        session.setAttribute("lastName", lastName);

                        response.setStatus(HttpServletResponse.SC_OK);
                        out.println("{\"success\": true, \"message\": \"Login successful\", \"userId\": " + userId +
                                   ", \"role\": \"" + role + "\", \"firstName\": \"" + firstName + "\"}");
                    } else {
                        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                        out.println("{\"success\": false, \"message\": \"Invalid username or password\"}");
                    }
                }
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            e.printStackTrace();
            out.println("{\"success\": false, \"message\": \"Server error: " + e.getMessage() + "\"}");
        } finally {
            out.close();
        }
    }
}

