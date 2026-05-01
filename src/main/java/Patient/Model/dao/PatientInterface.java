package Patient.Model.dao;
import Patient.Model.Patient;
import java.util.List;

public interface PatientInterface {
    boolean addPatient(Patient patient) throws Exception;
    boolean deletePatient(int userId) throws Exception;
    List<Patient> getAllPatients() throws Exception;
}