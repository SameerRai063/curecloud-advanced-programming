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

@WebServlet(name = "AddRatingServlet", urlPatterns = {"/AddRatingServlet", "/ratings/new"})
public class AddRatingServlet extends HttpServlet {
	private RatingService ratingService;

	@Override
	public void init() throws ServletException {
		ratingService = new RatingService();
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// Show the JSP form
		request.getRequestDispatcher("/rating/add-rating.jsp").forward(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			// CHECK: User must be logged in
			if (!AuthUtil.isLoggedIn(request)) {
				response.sendRedirect(request.getContextPath() + "/rating/rating-success.jsp?message=Please%20login%20first");
				return;
			}

			// CHECK: Only PATIENT can add ratings
			if (!AuthUtil.isPatient(request)) {
				response.sendRedirect(request.getContextPath() + "/rating/rating-success.jsp?message=Only%20patients%20can%20add%20ratings");
				return;
			}

			int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
			int score = Integer.parseInt(request.getParameter("score"));
			String review = request.getParameter("review");

			// Rule: rating score must be 1..5
			if (score < 1 || score > 5) {
				request.setAttribute("error", "Rating score must be between 1 and 5.");
				request.getRequestDispatcher("/rating/add-rating.jsp").forward(request, response);
				return;
			}

			Integer loggedInPatientId = AuthUtil.getUserId(request);
			if (loggedInPatientId == null) {
				response.sendRedirect(request.getContextPath() + "/rating/rating-success.jsp?message=Please%20login%20again");
				return;
			}

			int doctorId = 0;
			String doctorIdParam = request.getParameter("doctorId");
			if (doctorIdParam != null && !doctorIdParam.isBlank()) {
				doctorId = Integer.parseInt(doctorIdParam);
			}

			Rating rating = new Rating();
			rating.setPatientId(loggedInPatientId);
			rating.setDoctorId(doctorId);
			rating.setAppointmentId(appointmentId);
			rating.setScore(score);
			rating.setReview(review);

			boolean isSuccess = ratingService.submitRating(rating);
			
			if (isSuccess) {
				response.sendRedirect(request.getContextPath() + "/rating/rating-success.jsp?message=Rating%20submitted%20successfully");
			} else {
				// Either invalid, duplicate, or appointment not completed
				request.setAttribute("error", "Unable to submit rating. Make sure the appointment is COMPLETED and not already rated.");
				request.getRequestDispatcher("/rating/add-rating.jsp").forward(request, response);
			}
		} catch (NumberFormatException e) {
			request.setAttribute("error", "Invalid input format.");
			request.getRequestDispatcher("/rating/add-rating.jsp").forward(request, response);
		} catch (Exception e) {
			e.printStackTrace();
			request.setAttribute("error", "Server error: " + e.getMessage());
			request.getRequestDispatcher("/rating/add-rating.jsp").forward(request, response);
		}
	}
}

