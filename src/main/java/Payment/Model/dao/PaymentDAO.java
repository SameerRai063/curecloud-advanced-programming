package Payment.Model.dao;

import Payment.Model.Payment;
import java.util.List;
import Patient.Model.Patient;
import User.Model.User;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class PaymentDAO implements PaymentInterface {
    private Connection con;
    public  PaymentDAO(Connection con) {
        this.con = con;
    }


    public double getTotalRevenue() throws Exception {
        // COALESCE handles the case where the payment table is empty (SUM returns NULL)
        String sql = "SELECT COALESCE(SUM(amount), 0) FROM payments";
        try (PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getDouble(1) : 0.0;
        }
    }
    public List<Payment> getAllPayments() {

        List<Payment> paymentList = new ArrayList<>();

        String sql = "SELECT p.id, p.patient_id, p.appointment_id, p.amount, p.created_at, " +
                "u.id AS user_id, u.name " +
                "FROM payments p " +
                "JOIN patients pt ON p.patient_id = pt.user_id " +
                "JOIN users u ON pt.user_id = u.id " +
                "ORDER BY p.created_at DESC";

        try {

            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                // Create User object
                User user = new User();
                user.setId(rs.getInt("user_id"));
                user.setName(rs.getString("name"));

                // Create Patient object
                Patient patient = new Patient();
                patient.setUserId(rs.getInt("patient_id"));
                patient.setUser(user);

                // Create Payment object
                Payment payment = new Payment();
                payment.setId(rs.getInt("id"));
                payment.setPatientId(rs.getInt("patient_id"));
                payment.setAppointmentId(rs.getInt("appointment_id"));
                payment.setAmount(rs.getBigDecimal("amount"));
                payment.setCreatedAt(rs.getTimestamp("created_at"));

                // Attach patient object
                payment.setPatient(patient);

                paymentList.add(payment);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return paymentList;
    }
}
