package Payment.Controller;

import Payment.Model.Payment;
import Payment.Model.dao.PaymentDAO;

import utils.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;

@WebServlet("/billing")
public class ViewPaymentServlet extends HttpServlet {

    private PaymentDAO paymentDAO;

    @Override
    public void init() throws ServletException {

        try {

            Connection con = DBConnection.getConnection();

            paymentDAO = new PaymentDAO(con);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Payment> paymentList = paymentDAO.getAllPayments();

        request.setAttribute("paymentList", paymentList);

        request.getRequestDispatcher("/admin/billing.jsp")
                .forward(request, response);
    }
}