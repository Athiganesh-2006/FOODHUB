package com.foodhub.service;

import com.foodhub.config.JwtService;
import com.foodhub.dto.LoginRequest;
import com.foodhub.dto.LoginResponse;
import com.foodhub.entity.User;
import com.foodhub.repository.UserRepository;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;

    public AuthService(UserRepository userRepository, PasswordEncoder passwordEncoder,
                       JwtService jwtService) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
        this.jwtService = jwtService;
    }

    /**
     * 1. find the user  2. verify the password with BCrypt
     * 3. issue a signed JWT  4. return { token, user }.
     * Wrong email or password -> BadCredentialsException (mapped to HTTP 401).
     */
    public LoginResponse login(LoginRequest request) {
        User user = userRepository.findByEmail(request.getEmail())
                .orElseThrow(() -> new BadCredentialsException("Invalid email or password"));

        if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
            throw new BadCredentialsException("Invalid email or password");
        }

        String token = jwtService.generateToken(user);
        return LoginResponse.of(token, user);
    }
}
