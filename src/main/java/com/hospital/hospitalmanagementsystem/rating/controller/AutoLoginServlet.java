package com.hospital.hospitalmanagementsystem.rating.controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Temporary helper servlet for development/testing.
 * Usage:
 *   /AutoLoginServlet?user=admin
 *   /AutoLoginServlet?user=patient1&redirect=/rating/patient-ratings.jsp
 *
 * This servlet sets session attributes (userId, username, role, firstName, lastName)
 * for three seeded users (admin, patient1, doctor1) and redirects to `redirect` if provided.
 * Do NOT keep this enabled on production.
 */
@WebServlet("/AutoLoginServlet")
public class AutoLoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String user = request.getParameter("user");
        String redirect = request.getParameter("redirect");
        if (redirect == null || redirect.isBlank()) {
            redirect = request.getContextPath() + "/rating/view-ratings.jsp";
        } else if (!redirect.startsWith("/")) {
            redirect = request.getContextPath() + "/" + redirect;
        } else {
            redirect = request.getContextPath() + redirect;
        }

        HttpSession session = request.getSession(true);

        // Map known seeded users to session attributes (IDs match db/init_rating_schema.sql)
        if ("admin".equalsIgnoreCase(user)) {
            session.setAttribute("userId", 1);
            session.setAttribute("username", "admin");
            session.setAttribute("role", "ADMIN");
            session.setAttribute("firstName", "System");
            session.setAttribute("lastName", "Administrator");
        } else if ("patient1".equalsIgnoreCase(user)) {
            session.setAttribute("userId", 2);
            session.setAttribute("username", "patient1");
            session.setAttribute("role", "PATIENT");
            session.setAttribute("firstName", "John");
            session.setAttribute("lastName", "Doe");
        } else if ("doctor1".equalsIgnoreCase(user)) {
            session.setAttribute("userId", 3);
            session.setAttribute("username", "doctor1");
            session.setAttribute("role", "DOCTOR");
            session.setAttribute("firstName", "Alice");
            session.setAttribute("lastName", "Smith");
        } else {
            // unknown user param — clear session attributes used by the app
            session.removeAttribute("userId");
            session.removeAttribute("username");
            session.removeAttribute("role");
            session.removeAttribute("firstName");
            session.removeAttribute("lastName");
        }

        response.sendRedirect(redirect);
    }
}

