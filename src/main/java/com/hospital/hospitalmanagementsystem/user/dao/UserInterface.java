package com.hospital.hospitalmanagementsystem.user.dao;

import com.hospital.hospitalmanagementsystem.user.model.User;

public interface UserInterface {
    User findByUsernameAndPassword(String username, String password);
}

