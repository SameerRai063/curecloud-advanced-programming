package com.hospital.hospitalmanagementsystem.rating.controller;

import com.hospital.hospitalmanagementsystem.rating.service.RatingService;
import com.hospital.hospitalmanagementsystem.rating.util.AuthUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "DeleteRatingServlet", urlPatterns = {"/DeleteRatingServlet"})
public class DeleteRatingServlet extends HttpServlet {
	private RatingService ratingService;

	@Override
	public void init() throws ServletException {
		ratingService = new RatingService();
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
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
			boolean isSuccess = isAdmin ? ratingService.deleteRatingById(id) : ratingService.deleteRatingForPatient(id, userId);
			String message = isSuccess ? "Rating deleted successfully" : "Failed to delete rating";

			response.sendRedirect(request.getContextPath() + "/rating/rating-success.jsp?message=" + java.net.URLEncoder.encode(message, java.nio.charset.StandardCharsets.UTF_8));
		} catch (Exception e) {
			response.sendRedirect(request.getContextPath() + "/rating/rating-success.jsp?message=Invalid%20input");
		}
	}
}

