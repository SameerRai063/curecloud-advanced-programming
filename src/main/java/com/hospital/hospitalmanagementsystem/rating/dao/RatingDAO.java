package com.hospital.hospitalmanagementsystem.rating.dao;

import com.hospital.hospitalmanagementsystem.rating.model.Rating;
import utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

public class RatingDAO {

	public boolean isAppointmentCompletedForPatient(int patientId, int appointmentId) {
		String sql = "SELECT 1 FROM appointments WHERE id = ? AND patient_id = ? AND status = 'COMPLETED' LIMIT 1";
		try (Connection conn = DBConnection.getConnection();
			 PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, appointmentId);
			ps.setInt(2, patientId);
			try (ResultSet rs = ps.executeQuery()) {
				return rs.next();
			}
		} catch (SQLException | ClassNotFoundException e) {
			e.printStackTrace();
			return false;
		}
	}

	public Integer getDoctorIdForAppointment(int appointmentId) {
		String sql = "SELECT doctor_id FROM appointments WHERE id = ? LIMIT 1";
		try (Connection conn = DBConnection.getConnection();
			 PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, appointmentId);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) return rs.getInt("doctor_id");
				return null;
			}
		} catch (SQLException | ClassNotFoundException e) {
			e.printStackTrace();
			return null;
		}
	}

	public boolean hasDuplicateRating(int patientId, int appointmentId) {
		String sql = "SELECT 1 FROM ratings WHERE patient_id = ? AND appointment_id = ? LIMIT 1";
		try (Connection conn = DBConnection.getConnection();
			 PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, patientId);
			ps.setInt(2, appointmentId);
			try (ResultSet rs = ps.executeQuery()) {
				return rs.next();
			}
		} catch (SQLException | ClassNotFoundException e) {
			e.printStackTrace();
			return true;
		}
	}

	public boolean addRating(Rating rating) {
		String sql = "INSERT INTO ratings (patient_id, doctor_id, appointment_id, score, review, created_at) VALUES (?, ?, ?, ?, ?, ?)";

		try (Connection conn = DBConnection.getConnection();
			 PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, rating.getPatientId());
			pstmt.setInt(2, rating.getDoctorId());
			pstmt.setInt(3, rating.getAppointmentId());
			pstmt.setInt(4, rating.getScore());
			pstmt.setString(5, rating.getReview());
			pstmt.setTimestamp(6, new Timestamp(System.currentTimeMillis()));

			return pstmt.executeUpdate() > 0;
		} catch (SQLException | ClassNotFoundException e) {
			e.printStackTrace();
			return false;
		}
	}

	public Rating getRatingById(int id) {
		String sql = "SELECT id, patient_id, doctor_id, appointment_id, score, review, created_at FROM ratings WHERE id = ?";

		try (Connection conn = DBConnection.getConnection();
			 PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, id);

			try (ResultSet rs = pstmt.executeQuery()) {
				if (rs.next()) {
					Rating rating = mapRating(rs);
					return rating;
				}
			}
		} catch (SQLException | ClassNotFoundException e) {
			e.printStackTrace();
		}

		return null;
	}

	public Rating getRatingByIdDetailed(int id) {
		String sql = """
				SELECT r.id, r.patient_id, r.doctor_id, r.appointment_id, r.score, r.review, r.created_at,
					   CONCAT(du.first_name, ' ', du.last_name) AS doctor_name,
					   CONCAT(pu.first_name, ' ', pu.last_name) AS patient_name,
					   a.appointment_date AS appointment_date
				FROM ratings r
				LEFT JOIN appointments a ON a.id = r.appointment_id
				LEFT JOIN users du ON du.id = r.doctor_id
				LEFT JOIN users pu ON pu.id = r.patient_id
				WHERE r.id = ?
				LIMIT 1
				""";
		try (Connection conn = DBConnection.getConnection();
			 PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, id);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) return mapRatingDetailed(rs);
				return null;
			}
		} catch (SQLException | ClassNotFoundException e) {
			e.printStackTrace();
			return null;
		}
	}

	public List<Rating> getAllRatingsDetailed() {
		List<Rating> ratings = new ArrayList<>();
		String sql = """
				SELECT r.id, r.patient_id, r.doctor_id, r.appointment_id, r.score, r.review, r.created_at,
					   CONCAT(du.first_name, ' ', du.last_name) AS doctor_name,
					   CONCAT(pu.first_name, ' ', pu.last_name) AS patient_name,
					   a.appointment_date AS appointment_date
				FROM ratings r
				LEFT JOIN appointments a ON a.id = r.appointment_id
				LEFT JOIN users du ON du.id = r.doctor_id
				LEFT JOIN users pu ON pu.id = r.patient_id
				ORDER BY r.created_at DESC
				""";

		try (Connection conn = DBConnection.getConnection();
			 PreparedStatement pstmt = conn.prepareStatement(sql);
			 ResultSet rs = pstmt.executeQuery()) {

			while (rs.next()) {
				ratings.add(mapRatingDetailed(rs));
			}
		} catch (SQLException | ClassNotFoundException e) {
			e.printStackTrace();
		}

		return ratings;
	}

	public List<Rating> getRatingsByPatientId(int patientId) {
		List<Rating> ratings = new ArrayList<>();
		String sql = """
				SELECT r.id, r.patient_id, r.doctor_id, r.appointment_id, r.score, r.review, r.created_at,
					   CONCAT(du.first_name, ' ', du.last_name) AS doctor_name,
					   a.appointment_date AS appointment_date
				FROM ratings r
				LEFT JOIN appointments a ON a.id = r.appointment_id
				LEFT JOIN users du ON du.id = r.doctor_id
				WHERE r.patient_id = ?
				ORDER BY r.created_at DESC
				""";
		try (Connection conn = DBConnection.getConnection();
			 PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, patientId);
			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) ratings.add(mapRatingDetailed(rs));
			}
		} catch (SQLException | ClassNotFoundException e) {
			e.printStackTrace();
		}
		return ratings;
	}

	public List<Rating> getRatingsByDoctorId(int doctorId) {
		List<Rating> ratings = new ArrayList<>();
		String sql = """
				SELECT r.id, r.patient_id, r.doctor_id, r.appointment_id, r.score, r.review, r.created_at,
					   CONCAT(du.first_name, ' ', du.last_name) AS doctor_name,
					   CONCAT(pu.first_name, ' ', pu.last_name) AS patient_name,
					   a.appointment_date AS appointment_date
				FROM ratings r
				LEFT JOIN appointments a ON a.id = r.appointment_id
				LEFT JOIN users du ON du.id = r.doctor_id
				LEFT JOIN users pu ON pu.id = r.patient_id
				WHERE r.doctor_id = ?
				ORDER BY r.created_at DESC
				""";

		try (Connection conn = DBConnection.getConnection();
			 PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, doctorId);

			try (ResultSet rs = pstmt.executeQuery()) {
				while (rs.next()) {
					ratings.add(mapRatingDetailed(rs));
				}
			}
		} catch (SQLException | ClassNotFoundException e) {
			e.printStackTrace();
		}

		return ratings;
	}

	public boolean updateRatingForPatient(int ratingId, int patientId, int score, String review) {
		String sql = "UPDATE ratings SET score = ?, review = ? WHERE id = ? AND patient_id = ?";

		try (Connection conn = DBConnection.getConnection();
			 PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, score);
			pstmt.setString(2, review);
			pstmt.setInt(3, ratingId);
			pstmt.setInt(4, patientId);

			return pstmt.executeUpdate() > 0;
		} catch (SQLException | ClassNotFoundException e) {
			e.printStackTrace();
			return false;
		}
	}

	public boolean updateRatingById(int ratingId, int score, String review) {
		String sql = "UPDATE ratings SET score = ?, review = ? WHERE id = ?";

		try (Connection conn = DBConnection.getConnection();
			 PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, score);
			pstmt.setString(2, review);
			pstmt.setInt(3, ratingId);

			return pstmt.executeUpdate() > 0;
		} catch (SQLException | ClassNotFoundException e) {
			e.printStackTrace();
			return false;
		}
	}

	public boolean deleteRatingForPatient(int id, int patientId) {
		String sql = "DELETE FROM ratings WHERE id = ? AND patient_id = ?";

		try (Connection conn = DBConnection.getConnection();
			 PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, id);
			pstmt.setInt(2, patientId);
			return pstmt.executeUpdate() > 0;
		} catch (SQLException | ClassNotFoundException e) {
			e.printStackTrace();
			return false;
		}
	}

	public boolean deleteRatingById(int id) {
		String sql = "DELETE FROM ratings WHERE id = ?";

		try (Connection conn = DBConnection.getConnection();
			 PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, id);
			return pstmt.executeUpdate() > 0;
		} catch (SQLException | ClassNotFoundException e) {
			e.printStackTrace();
			return false;
		}
	}

	private Rating mapRating(ResultSet rs) throws SQLException {
		Rating rating = new Rating();
		rating.setId(rs.getInt("id"));
		rating.setPatientId(rs.getInt("patient_id"));
		rating.setDoctorId(rs.getInt("doctor_id"));
		rating.setAppointmentId(rs.getInt("appointment_id"));
		rating.setScore(rs.getInt("score"));
		rating.setReview(rs.getString("review"));
		rating.setCreatedAt(rs.getTimestamp("created_at"));
		return rating;
	}

	private Rating mapRatingDetailed(ResultSet rs) throws SQLException {
		Rating rating = mapRating(rs);
		try { rating.setDoctorName(rs.getString("doctor_name")); } catch (SQLException ignored) {}
		rating.setDoctorPhoto(buildDoctorAvatar(rating.getDoctorName()));
		try { rating.setPatientName(rs.getString("patient_name")); } catch (SQLException ignored) {}
		try { rating.setAppointmentDate(rs.getString("appointment_date")); } catch (SQLException ignored) {}
		return rating;
	}

	private String buildDoctorAvatar(String fullName) {
		String initials = "Dr";
		if (fullName != null && !fullName.isBlank()) {
			String[] parts = fullName.trim().split("\\s+");
			StringBuilder builder = new StringBuilder();
			for (String part : parts) {
				if (!part.isBlank()) {
					builder.append(Character.toUpperCase(part.charAt(0)));
					if (builder.length() == 2) break;
				}
			}
			if (builder.length() > 0) {
				initials = builder.toString();
			}
		}

		String svg = "<svg xmlns='http://www.w3.org/2000/svg' width='120' height='120' viewBox='0 0 120 120'>"
				+ "<defs><linearGradient id='g' x1='0' x2='1' y1='0' y2='1'><stop offset='0%' stop-color='#1d4ed8'/><stop offset='100%' stop-color='#1e3a8a'/></linearGradient></defs>"
				+ "<rect width='120' height='120' rx='60' fill='url(#g)'/>"
				+ "<circle cx='60' cy='46' r='18' fill='white' opacity='0.95'/>"
				+ "<path d='M30 102c4-20 18-32 30-32s26 12 30 32' fill='white' opacity='0.95'/>"
				+ "<text x='60' y='64' text-anchor='middle' font-family='Arial, sans-serif' font-size='20' font-weight='700' fill='#1e3a8a'>"
				+ initials + "</text>"
				+ "</svg>";
		return "data:image/svg+xml;utf8," + URLEncoder.encode(svg, StandardCharsets.UTF_8);
	}
}


