package com.example.expense.controller;

import com.example.expense.dto.ExpenseFilter;
import com.example.expense.dto.ExpenseRequest;
import com.example.expense.dto.ExpenseResponse;
import com.example.expense.model.ExpenseCategory;
import com.example.expense.service.ExpenseService;
import jakarta.validation.Valid;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import java.time.Instant;
import java.util.List;

@RestController
@RequestMapping("/api/expenses")
public class ExpenseController {

    private final ExpenseService expenseService;

    public ExpenseController(ExpenseService expenseService) {
        this.expenseService = expenseService;
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ExpenseResponse createExpense(@RequestHeader("X-USER-ID") String userId,
                                         @Valid @RequestBody ExpenseRequest request) {
        return expenseService.createExpense(request, userId);
    }

    @GetMapping
    public List<ExpenseResponse> listExpenses(
            @RequestParam(required = false) String category,
            @RequestHeader("X-USER-ID") String userId,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) Instant startDate
    ) {
        ExpenseCategory parsedCategory = category == null ? null : ExpenseCategory.fromValue(category);
        ExpenseFilter filter = new ExpenseFilter(userId, parsedCategory, startDate);
        return expenseService.listExpenses(filter);
    }

    @PutMapping("/{id}")
    public ExpenseResponse updateExpense(@RequestHeader("X-USER-ID") String userId,
                                         @PathVariable String id,
                                         @Valid @RequestBody ExpenseRequest request) {
        return expenseService.updateExpense(id, request, userId);
    }

    @DeleteMapping("/{id}")
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void deleteExpense(@RequestHeader("X-USER-ID") String userId,
                              @PathVariable String id) {
        expenseService.deleteExpense(id, userId);
    }
}

