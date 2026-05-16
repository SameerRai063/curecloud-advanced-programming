package Feedback.Controller;

import Feedback.Model.Feedback;
import Feedback.Model.dao.FeedbackDAO;
import utils.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;

@WebServlet("/feedback")
public class FeedbackServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ── 1. Auth guard ──────────────────────────────────────────────────
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Connection con = null;
        try {
            con = DBConnection.getConnection();
            FeedbackDAO feedbackDAO = new FeedbackDAO(con);

            // ── 2. Total feedback count ────────────────────────────────────
            int totalFeedback = feedbackDAO.countTotalFeedback();
            request.setAttribute("totalFeedback", totalFeedback);

            // ── 3. All feedback list ───────────────────────────────────────
            List<Feedback> feedbackList = feedbackDAO.getAllFeedback();
            request.setAttribute("feedbackList", feedbackList);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to load feedback data.");
        } finally {
            try { if (con != null) con.close(); } catch (Exception ignored) {}
        }

        // ── 4. Forward to feedback JSP ─────────────────────────────────────
        request.getRequestDispatcher("/admin/feedback.jsp")
                .forward(request, response);
    }
}