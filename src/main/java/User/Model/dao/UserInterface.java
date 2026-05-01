package User.Model.dao;

import User.Model.User;

public interface UserInterface {
    boolean updateUser(User user) throws Exception;
    int addUser(User user) throws Exception;
    boolean deleteUser(int userId) throws Exception;
    User getUserByEmail(String email) throws Exception;
}