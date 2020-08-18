package com.demo.auth.service;

import com.demo.auth.model.User;

public interface UserService {
    void save(User user);

    User findByUsername(String username);
}
