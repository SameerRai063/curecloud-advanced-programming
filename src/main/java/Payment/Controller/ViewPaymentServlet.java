package Payment.Controller;

import Payment.Model.Payment;
import Payment.Model.dao.PaymentDAO;
import utils.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;

@WebServlet("/billing")
public class ViewPaymentServlet extends HttpServlet {

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
            con = DBConnection.getConnection(); // ✅ actually open the connection
            PaymentDAO paymentDAO = new PaymentDAO(con);

            // ── 2. Total revenue ───────────────────────────────────────────
            double totalRevenue = paymentDAO.getTotalRevenue();
            request.setAttribute("totalRevenue", totalRevenue);

            // ── 3. All payments — set as "billingList" to match JSP ────────
            List<Payment> payments = paymentDAO.getAllPayments();
            request.setAttribute("billingList", payments); // ✅ matches ${billingList}

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to load billing data.");
        } finally {
            try { if (con != null) con.close(); } catch (Exception ignored) {}
        }

        // ── 4. Forward to billing JSP ──────────────────────────────────────
        request.getRequestDispatcher("/admin/billing.jsp")
                .forward(request, response);
    }
}