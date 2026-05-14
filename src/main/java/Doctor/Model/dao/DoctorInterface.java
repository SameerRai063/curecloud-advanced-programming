package Doctor.Model.dao;

import Doctor.Model.Doctor;
import java.util.List;
import java.util.Map;

public interface DoctorInterface {

    boolean addDoctor(Doctor doctor) throws Exception;
    boolean deleteDoctor(int userId) throws Exception;
    boolean updateDoctor(Doctor doctor) throws Exception;
    // Retrieves a list of all doctors with their user details attached
    int getTotalDoctors() throws Exception;
    List<Doctor> getAllDoctors() throws Exception;
    public Map<String, Integer> getDoctorStats() throws Exception;
}