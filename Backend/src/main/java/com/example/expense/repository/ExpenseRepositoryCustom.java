package com.example.expense.repository;

import com.example.expense.dto.ExpenseFilter;
import com.example.expense.model.ExpenseDocument;

import java.util.List;

public interface ExpenseRepositoryCustom {

    List<ExpenseDocument> findByFilter(ExpenseFilter filter);
}

