package com.example.expense.service;

import com.example.expense.dto.ExpenseFilter;
import com.example.expense.dto.ExpenseRequest;
import com.example.expense.dto.ExpenseResponse;
import com.example.expense.exception.ExpenseNotFoundException;
import com.example.expense.exception.UnauthorizedExpenseAccessException;
import com.example.expense.mapper.ExpenseMapper;
import com.example.expense.model.ExpenseDocument;
import com.example.expense.repository.ExpenseRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class ExpenseServiceImpl implements ExpenseService {

    private final ExpenseRepository repository;

    public ExpenseServiceImpl(ExpenseRepository repository) {
        this.repository = repository;
    }

    @Override
    public ExpenseResponse createExpense(ExpenseRequest request, String userId) {
        ExpenseDocument document = ExpenseMapper.toDocument(request, userId);
        ExpenseDocument saved = repository.save(document);
        return ExpenseMapper.toResponse(saved);
    }

    @Override
    public ExpenseResponse updateExpense(String id, ExpenseRequest request, String userId) {
        ExpenseDocument existing = repository.findById(id)
                .orElseThrow(() -> new ExpenseNotFoundException(id));
        if (!existing.getUserId().equals(userId)) {
            throw new UnauthorizedExpenseAccessException();
        }
        ExpenseDocument merged = ExpenseMapper.merge(existing, request);
        ExpenseDocument saved = repository.save(merged);
        return ExpenseMapper.toResponse(saved);
    }

    @Override
    public void deleteExpense(String id, String userId) {
        ExpenseDocument document = repository.findById(id)
                .orElseThrow(() -> new ExpenseNotFoundException(id));
        if (!document.getUserId().equals(userId)) {
            throw new UnauthorizedExpenseAccessException();
        }
        repository.deleteById(id);
    }

    @Override
    @Transactional(readOnly = true)
    public List<ExpenseResponse> listExpenses(ExpenseFilter filter) {
        return repository.findByFilter(filter)
                .stream()
                .map(ExpenseMapper::toResponse)
                .toList();
    }
}

