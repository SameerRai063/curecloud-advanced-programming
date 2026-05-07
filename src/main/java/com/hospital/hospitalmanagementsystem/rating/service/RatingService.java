package com.hospital.hospitalmanagementsystem.rating.service;

import com.hospital.hospitalmanagementsystem.rating.dao.RatingDAO;
import com.hospital.hospitalmanagementsystem.rating.model.Rating;

import java.util.List;

public class RatingService {
	private final RatingDAO ratingDAO;

	public RatingService() {
		this.ratingDAO = new RatingDAO();
	}

	public boolean submitRating(Rating rating) {
		if (!isValid(rating)) {
			return false;
		}
		// Rule: allow rating only if appointment is completed (for this patient)
		if (!ratingDAO.isAppointmentCompletedForPatient(rating.getPatientId(), rating.getAppointmentId())) {
			return false;
		}
		// Rule: prevent duplicate rating per appointment
		if (ratingDAO.hasDuplicateRating(rating.getPatientId(), rating.getAppointmentId())) {
			return false;
		}
		// If doctorId was not reliably provided, fetch from appointment
		if (rating.getDoctorId() <= 0) {
			Integer doctorId = ratingDAO.getDoctorIdForAppointment(rating.getAppointmentId());
			if (doctorId == null || doctorId <= 0) return false;
			rating.setDoctorId(doctorId);
		}
		return ratingDAO.addRating(rating);
	}

	public boolean updateRatingForPatient(int ratingId, int patientId, int score, String review) {
		if (ratingId <= 0 || patientId <= 0) return false;
		if (score < 1 || score > 5) return false;
		return ratingDAO.updateRatingForPatient(ratingId, patientId, score, review);
	}

	public boolean updateRatingById(int ratingId, int score, String review) {
		if (ratingId <= 0) return false;
		if (score < 1 || score > 5) return false;
		return ratingDAO.updateRatingById(ratingId, score, review);
	}

	public boolean deleteRatingForPatient(int id, int patientId) {
		return id > 0 && patientId > 0 && ratingDAO.deleteRatingForPatient(id, patientId);
	}

	public boolean deleteRatingById(int id) {
		return id > 0 && ratingDAO.deleteRatingById(id);
	}

	public Rating getRatingById(int id) {
		if (id <= 0) {
			return null;
		}
		return ratingDAO.getRatingByIdDetailed(id);
	}

	public List<Rating> getAllRatings() {
		return ratingDAO.getAllRatingsDetailed();
	}

	public List<Rating> getDoctorRatings(int doctorId) {
		return ratingDAO.getRatingsByDoctorId(doctorId);
	}

	public List<Rating> getPatientRatings(int patientId) {
		return ratingDAO.getRatingsByPatientId(patientId);
	}

	private boolean isValid(Rating rating) {
		return rating != null
				&& rating.getPatientId() > 0
				&& rating.getAppointmentId() > 0
				&& rating.getScore() >= 1
				&& rating.getScore() <= 5;
	}
}

