package Patient.Model.dao;

import Patient.Model.Patient;

import java.sql.Connection;
import java.sql.PreparedStatement;

public class PatientDAO implements PatientInterface {

    private Connection con;

    public PatientDAO(Connection con) {
        this.con = con;
    }

    @Override
    public boolean addPatient(Patient patient) throws Exception {

        String sql = "INSERT INTO patient(user_id, blood_group, is_active) VALUES (?, ?, ?)";

        PreparedStatement ps = con.prepareStatement(sql);

        ps.setInt(1, patient.getUserId());
        ps.setString(2, patient.getBloodGroup());
        ps.setString(3, patient.isActive() ? "yes" : "no");

        return ps.executeUpdate() > 0;
    }
}