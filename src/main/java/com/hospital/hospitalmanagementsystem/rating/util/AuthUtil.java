package com.hospital.hospitalmanagementsystem.rating.util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

public class AuthUtil {

    /**
     * Check if user is logged in
     */
    public static boolean isLoggedIn(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null && session.getAttribute("userId") != null;
    }

    /**
     * Get user ID from session
     */
    public static Integer getUserId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            Object userId = session.getAttribute("userId");
            if (userId instanceof Integer) {
                return (Integer) userId;
            }
        }
        return null;
    }

    /**
     * Get user role from session
     */
    public static String getUserRole(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            return (String) session.getAttribute("role");
        }
        return null;
    }

    /**
     * Check if user is ADMIN
     */
    public static boolean isAdmin(HttpServletRequest request) {
        return "ADMIN".equals(getUserRole(request));
    }

    /**
     * Check if user is DOCTOR
     */
    public static boolean isDoctor(HttpServletRequest request) {
        return "DOCTOR".equals(getUserRole(request));
    }

    /**
     * Check if user is PATIENT
     */
    public static boolean isPatient(HttpServletRequest request) {
        return "PATIENT".equals(getUserRole(request));
    }

    /**
     * Get username from session
     */
    public static String getUsername(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            return (String) session.getAttribute("username");
        }
        return null;
    }
}

