package com.example.expense.dto;

import com.example.expense.model.ExpenseCategory;

import java.math.BigDecimal;
import java.time.Instant;

public record ExpenseResponse(
        String id,
        BigDecimal amount,
        String description,
        Instant date,
        ExpenseCategory category
) {
}

