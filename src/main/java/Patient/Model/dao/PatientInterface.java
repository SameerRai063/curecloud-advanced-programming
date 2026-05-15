package Patient.Model.dao;
import Patient.Model.Patient;
import java.util.List;

public interface PatientInterface {
    public Patient getPatientById(int userId) throws Exception;
    public boolean registerPatient(Patient patient) throws Exception;
    boolean addPatient(Patient patient) throws Exception;
    boolean deletePatient(int userId) throws Exception;
    boolean updatePatientProfile(Patient patient, String currentPassword, String newPassword) throws  Exception;
    int getTotalPatients() throws Exception;
    List<Patient> getAllPatients() throws Exception;
}