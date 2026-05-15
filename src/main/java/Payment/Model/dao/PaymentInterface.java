package Payment.Model.dao;

import Payment.Model.Payment;

import java.util.List;

public interface PaymentInterface {
    double getTotalRevenue() throws Exception;
    public List<Payment> getAllPayments() throws Exception;
    public boolean addPayment(Payment payment) throws Exception;
}
