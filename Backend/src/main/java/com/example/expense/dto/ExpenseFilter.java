package com.example.expense.dto;

import com.example.expense.model.ExpenseCategory;

import java.time.Instant;
import java.util.Optional;

public record ExpenseFilter(
        String userId,
        ExpenseCategory category,
        Instant startDate
) {

    public Optional<ExpenseCategory> categoryOpt() {
        return Optional.ofNullable(category);
    }

    public Optional<Instant> startDateOpt() {
        return Optional.ofNullable(startDate);
    }

}

