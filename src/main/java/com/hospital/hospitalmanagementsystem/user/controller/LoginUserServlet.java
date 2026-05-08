package com.hospital.hospitalmanagementsystem.user.controller;

import com.hospital.hospitalmanagementsystem.user.dao.UserDAO;
import com.hospital.hospitalmanagementsystem.user.model.User;
import com.hospital.hospitalmanagementsystem.rating.util.AuthUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "LoginUserServlet", urlPatterns = {"/LoginUserServlet", "/user/login"})
public class LoginUserServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        if (username == null || password == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?error=Missing%20credentials");
            return;
        }

        User user = userDAO.findByUsernameAndPassword(username, password);
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?error=Invalid%20username%20or%20password");
            return;
        }

        // Set session attributes expected by AuthUtil
        req.getSession(true).setAttribute("userId", user.getId());
        req.getSession().setAttribute("role", user.getRole());
        req.getSession().setAttribute("username", user.getUsername());

        // Redirect based on role
        String role = user.getRole();
        if ("ADMIN".equals(role)) {
            resp.sendRedirect(req.getContextPath() + "/rating/view-ratings.jsp");
        } else if ("DOCTOR".equals(role)) {
            resp.sendRedirect(req.getContextPath() + "/rating/doctor-ratings.jsp");
        } else {
            resp.sendRedirect(req.getContextPath() + "/rating/patient-ratings.jsp");
        }
    }
}

