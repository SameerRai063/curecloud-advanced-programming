package Receptionist.Model.dao;

import Receptionist.Model.Receptionist;
import java.util.List;

public interface ReceptionistInterface {

boolean addReceptionist(Receptionist receptionist) throws Exception;
    boolean updateReceptionistProfile(Receptionist receptionist, String currentPassword, String newPassword) throws Exception;

    // Retrieves a list of all receptionists with their user details attached
    List<Receptionist> getAllReceptionists() throws Exception;

    int getTotalReceptionists() throws Exception;
    public Receptionist getReceptionistById(int userId) throws Exception;
    // Count receptionists whose status is active
    int countActiveReceptionists() throws Exception;
    public boolean deleteReceptionist(int userId) throws Exception;
    // Count receptionists whose status is on leave
    int countOnLeaveReceptionists() throws Exception;
}