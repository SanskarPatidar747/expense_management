package com.example.expense.service;

import com.example.expense.dto.AuthResponse;
import com.example.expense.dto.LoginRequest;
import com.example.expense.dto.SignupRequest;

public interface AuthService {

    AuthResponse signup(SignupRequest request);

    AuthResponse login(LoginRequest request);
}


