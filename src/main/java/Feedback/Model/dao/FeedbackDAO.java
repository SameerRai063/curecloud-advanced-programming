package Feedback.Model.dao;

import Feedback.Model.Feedback;
import utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FeedbackDAO {

    private final Connection con;

    public FeedbackDAO(Connection con) {
        this.con = con;
    }

    // ── Count total feedbacks ──────────────────────────────────────────────
    public int countTotalFeedback() {
        String sql = "SELECT COUNT(*) FROM feedback";
        try (PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    // ── List all feedbacks with patient name ───────────────────────────────
    public List<Feedback> getAllFeedback() {
        List<Feedback> feedbackList = new ArrayList<>();

        String sql = """
                SELECT f.id,
                       f.patient_id,
                       u.name AS patient_name,
                       f.comment,
                       f.rating,
                       f.created_at
                FROM   feedback f
                JOIN   users u ON u.id = f.patient_id
                ORDER  BY f.created_at DESC
                """;

        try (PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Feedback feedback = new Feedback();
                feedback.setId(rs.getInt("id"));
                feedback.setPatientId(rs.getInt("patient_id"));
                feedback.setComment(rs.getString("comment"));
                feedback.setRating(rs.getInt("rating"));
                feedback.setCreatedAt(rs.getTimestamp("created_at"));

                // store patient name as a transient field (see note below)
                feedback.setPatientName(rs.getString("patient_name"));

                feedbackList.add(feedback);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return feedbackList;
    }
}