package Doctor.Model.dao;

import Doctor.Model.Doctor;
import java.util.List;

public interface DoctorInterface {

    boolean addDoctor(Doctor doctor) throws Exception;
    boolean deleteDoctor(int userId) throws Exception;
    // Retrieves a list of all doctors with their user details attached
    List<Doctor> getAllDoctors() throws Exception;
}