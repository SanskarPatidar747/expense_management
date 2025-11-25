package com.example.expense.dto;

public record AuthResponse(
        String token,
        UserResponse user
) {
}


