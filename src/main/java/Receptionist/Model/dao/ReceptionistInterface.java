package Receptionist.Model.dao;

import Receptionist.Model.Receptionist;
import java.util.List;

public interface ReceptionistInterface {

    boolean addReceptionist(Receptionist receptionist) throws Exception;

    boolean deleteReceptionist(int userId) throws Exception;

    boolean updateReceptionist(Receptionist receptionist) throws Exception;

    // Retrieves a list of all receptionists with their user details attached
    List<Receptionist> getAllReceptionists() throws Exception;

    int getTotalReceptionists() throws Exception;

    // Count receptionists whose status is active
    int countActiveReceptionists() throws Exception;

    // Count receptionists whose status is on leave
    int countOnLeaveReceptionists() throws Exception;
}