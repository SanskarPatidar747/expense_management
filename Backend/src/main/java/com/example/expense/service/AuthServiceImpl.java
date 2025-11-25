package com.example.expense.service;

import com.example.expense.dto.AuthResponse;
import com.example.expense.dto.LoginRequest;
import com.example.expense.dto.SignupRequest;
import com.example.expense.dto.UserResponse;
import com.example.expense.exception.InvalidCredentialsException;
import com.example.expense.exception.UserAlreadyExistsException;
import com.example.expense.model.UserDocument;
import com.example.expense.repository.UserRepository;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.Instant;

@Service
public class AuthServiceImpl implements AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    public AuthServiceImpl(UserRepository userRepository) {
        this.userRepository = userRepository;
        this.passwordEncoder = new BCryptPasswordEncoder();
    }

    @Override
    public AuthResponse signup(SignupRequest request) {
        userRepository.findByEmailIgnoreCase(request.getEmail())
                .ifPresent(existing -> {
                    throw new UserAlreadyExistsException(existing.getEmail());
                });

        UserDocument document = new UserDocument();
        document.setName(request.getName());
        document.setEmail(request.getEmail().toLowerCase());
        document.setPasswordHash(passwordEncoder.encode(request.getPassword()));
        document.setCreatedAt(Instant.now());

        UserDocument saved = userRepository.save(document);
        return toAuthResponse(saved);
    }

    @Override
    public AuthResponse login(LoginRequest request) {
        UserDocument user = userRepository.findByEmailIgnoreCase(request.getEmail())
                .orElseThrow(InvalidCredentialsException::new);

        if (!passwordEncoder.matches(request.getPassword(), user.getPasswordHash())) {
            throw new InvalidCredentialsException();
        }

        return toAuthResponse(user);
    }

    private AuthResponse toAuthResponse(UserDocument user) {
        return new AuthResponse(
                user.getId(),
                new UserResponse(user.getId(), user.getName(), user.getEmail())
        );
    }
}



