package com.demo.auth.service;

import com.demo.auth.common.EntityServiceImpl;
import com.demo.auth.model.User;
import com.demo.auth.repository.RoleRepository;
import com.demo.auth.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.HashSet;

@Service("userService")
public class UserServiceImpl extends EntityServiceImpl<Long, User> implements UserService {
    
	@Autowired
    private UserRepository userRepository;
    @Autowired
    private RoleRepository roleRepository;
    @Autowired
    private BCryptPasswordEncoder bCryptPasswordEncoder;
	
	
    public UserServiceImpl(UserRepository userRepository) {
		super(userRepository);
		this.userRepository = userRepository;
	}

	

    @Override
    public void save(User user) {
        user.setPassword(bCryptPasswordEncoder.encode(user.getPassword()));
        user.setRoles(new HashSet<>(roleRepository.findAll()));
        userRepository.save(user);
    }

    @Override
    public User findByUsername(String username) {
        return userRepository.findByUsername(username);
    }
}
