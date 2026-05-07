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

@WebServlet(name = "DoctorRatingServlet", urlPatterns = {"/DoctorRatingServlet", "/ratings/doctor"})
public class DoctorRatingServlet extends HttpServlet {
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
			if (!AuthUtil.isDoctor(request)) {
				response.sendRedirect(request.getContextPath() + "/rating/rating-success.jsp?message=Only%20doctors%20can%20view%20this%20page");
				return;
			}

			Integer doctorId = AuthUtil.getUserId(request);
			if (doctorId == null) {
				response.sendRedirect(request.getContextPath() + "/rating/rating-success.jsp?message=Please%20login%20again");
				return;
			}

			List<Rating> ratingsList = ratingService.getDoctorRatings(doctorId);
			if (!ratingsList.isEmpty()) {
				request.setAttribute("doctorName", ratingsList.get(0).getDoctorName());
				request.setAttribute("doctorPhoto", ratingsList.get(0).getDoctorPhoto());
			}
			request.setAttribute("ratings", ratingsList);
			request.getRequestDispatcher("/rating/doctor-ratings.jsp").forward(request, response);
		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect(request.getContextPath() + "/rating/rating-success.jsp?message=Server%20error");
		}
	}
}

