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

@WebServlet(name = "UpdateRatingServlet", urlPatterns = {"/UpdateRatingServlet"})
public class UpdateRatingServlet extends HttpServlet {
	private RatingService ratingService;

	@Override
	public void init() throws ServletException {
		ratingService = new RatingService();
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			if (!AuthUtil.isLoggedIn(request)) {
				response.sendRedirect(request.getContextPath() + "/rating/rating-success.jsp?message=Please%20login%20first");
				return;
			}

			boolean isPatient = AuthUtil.isPatient(request);
			boolean isAdmin = AuthUtil.isAdmin(request);
			if (!isPatient && !isAdmin) {
				response.sendRedirect(request.getContextPath() + "/rating/rating-success.jsp?message=Access%20Denied");
				return;
			}

			Integer patientId = AuthUtil.getUserId(request);
			if (patientId == null) {
				response.sendRedirect(request.getContextPath() + "/rating/rating-success.jsp?message=Please%20login%20again");
				return;
			}

			int id = Integer.parseInt(request.getParameter("id"));
			Rating rating = ratingService.getRatingById(id);
			if (rating == null || (isPatient && rating.getPatientId() != patientId)) {
				response.sendRedirect(request.getContextPath() + "/rating/rating-success.jsp?message=You%20can%20only%20edit%20your%20own%20rating");
				return;
			}

			request.setAttribute("rating", rating);
			request.getRequestDispatcher("/rating/edit-rating.jsp").forward(request, response);
		} catch (NumberFormatException e) {
			response.sendRedirect(request.getContextPath() + "/rating/rating-success.jsp?message=Invalid%20input");
		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect(request.getContextPath() + "/rating/rating-success.jsp?message=Server%20error");
		}
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			if (!AuthUtil.isLoggedIn(request)) {
				response.sendRedirect(request.getContextPath() + "/rating/rating-success.jsp?message=Please%20login%20first");
				return;
			}

			boolean isPatient = AuthUtil.isPatient(request);
			boolean isAdmin = AuthUtil.isAdmin(request);
			if (!isPatient && !isAdmin) {
				response.sendRedirect(request.getContextPath() + "/rating/rating-success.jsp?message=Access%20Denied");
				return;
			}

			Integer userId = AuthUtil.getUserId(request);
			if (userId == null) {
				response.sendRedirect(request.getContextPath() + "/rating/rating-success.jsp?message=Please%20login%20again");
				return;
			}

			int id = Integer.parseInt(request.getParameter("id"));
			int score = Integer.parseInt(request.getParameter("score"));
			String review = request.getParameter("review");

			if (score < 1 || score > 5) {
				Rating rating = ratingService.getRatingById(id);
				request.setAttribute("rating", rating);
				request.setAttribute("error", "Rating score must be between 1 and 5.");
				request.getRequestDispatcher("/rating/edit-rating.jsp").forward(request, response);
				return;
			}

			boolean isSuccess = isAdmin
					? ratingService.updateRatingById(id, score, review)
					: ratingService.updateRatingForPatient(id, userId, score, review);
			if (isSuccess) {
				response.sendRedirect(request.getContextPath() + "/rating/rating-success.jsp?message=Rating%20updated%20successfully");
			} else {
				response.sendRedirect(request.getContextPath() + "/rating/rating-success.jsp?message=Failed%20to%20update%20rating");
			}
		} catch (NumberFormatException e) {
			response.sendRedirect(request.getContextPath() + "/rating/rating-success.jsp?message=Invalid%20input");
		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect(request.getContextPath() + "/rating/rating-success.jsp?message=Server%20error");
		}
	}
}

