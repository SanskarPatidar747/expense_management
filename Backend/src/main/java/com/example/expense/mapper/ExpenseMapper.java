package com.example.expense.mapper;

import com.example.expense.dto.ExpenseRequest;
import com.example.expense.dto.ExpenseResponse;
import com.example.expense.model.ExpenseDocument;

public final class ExpenseMapper {

    private ExpenseMapper() {
    }

    public static ExpenseDocument toDocument(ExpenseRequest request, String userId) {
        return new ExpenseDocument(
                null,
                request.getAmount(),
                request.getDescription(),
                request.getDate(),
                request.getCategory(),
                userId
        );
    }

    public static ExpenseDocument merge(ExpenseDocument existing, ExpenseRequest request) {
        existing.setAmount(request.getAmount());
        existing.setDescription(request.getDescription());
        existing.setDate(request.getDate());
        existing.setCategory(request.getCategory());
        return existing;
    }

    public static ExpenseResponse toResponse(ExpenseDocument document) {
        return new ExpenseResponse(
                document.getId(),
                document.getAmount(),
                document.getDescription(),
                document.getDate(),
                document.getCategory()
        );
    }
}

