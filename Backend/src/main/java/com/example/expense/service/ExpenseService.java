package com.example.expense.service;

import com.example.expense.dto.ExpenseFilter;
import com.example.expense.dto.ExpenseRequest;
import com.example.expense.dto.ExpenseResponse;

import java.util.List;

public interface ExpenseService {

    ExpenseResponse createExpense(ExpenseRequest request, String userId);

    ExpenseResponse updateExpense(String id, ExpenseRequest request, String userId);

    void deleteExpense(String id, String userId);

    List<ExpenseResponse> listExpenses(ExpenseFilter filter);
}

