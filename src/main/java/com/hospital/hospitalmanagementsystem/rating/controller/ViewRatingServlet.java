package com.hospital.hospitalmanagementsystem.rating.controller;

import com.hospital.hospitalmanagementsystem.rating.model.Rating;
import com.hospital.hospitalmanagementsystem.rating.service.RatingService;
import com.hospital.hospitalmanagementsystem.rating.util.AuthUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ViewRatingServlet", urlPatterns = {"/ViewRatingServlet", "/ratings"})
public class ViewRatingServlet extends HttpServlet {
	private RatingService ratingService;

	@Override
	public void init() throws ServletException {
		ratingService = new RatingService();
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			// CHECK: User must be logged in
			if (!AuthUtil.isLoggedIn(request)) {
				response.sendRedirect(request.getContextPath() + "/rating/rating-success.jsp?message=Please%20login%20first");
				return;
			}

			Integer userId = AuthUtil.getUserId(request);
			List<Rating> ratings;

			if (AuthUtil.isAdmin(request)) {
				// ADMIN: View all ratings
				ratings = ratingService.getAllRatings();
			} else if (AuthUtil.isDoctor(request)) {
				// DOCTOR: View ratings for themselves (as doctor_id)
				if (userId == null) {
					response.sendRedirect(request.getContextPath() + "/rating/rating-success.jsp?message=Please%20login%20again");
					return;
				}
				ratings = ratingService.getDoctorRatings(userId);
			} else if (AuthUtil.isPatient(request)) {
				// PATIENT: View only their own ratings (as patient_id)
				if (userId == null) {
					response.sendRedirect(request.getContextPath() + "/rating/rating-success.jsp?message=Please%20login%20again");
					return;
				}
				ratings = ratingService.getPatientRatings(userId);
			} else {
				response.sendRedirect(request.getContextPath() + "/rating/rating-success.jsp?message=Invalid%20role");
				return;
			}

			request.setAttribute("ratings", ratings);
			if (AuthUtil.isAdmin(request)) {
				// ADMIN: show admin view (all ratings)
				request.getRequestDispatcher("/rating/view-ratings.jsp").forward(request, response);
			} else if (AuthUtil.isDoctor(request)) {
				// DOCTOR: show doctor-specific ratings page
				request.getRequestDispatcher("/rating/doctor-ratings.jsp").forward(request, response);
			} else {
				// PATIENT or others: show patient ratings page
				request.getRequestDispatcher("/rating/patient-ratings.jsp").forward(request, response);
			}
		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect(request.getContextPath() + "/rating/rating-success.jsp?message=Server%20error");
		}
	}
}

