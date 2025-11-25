package com.example.expense.model;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;

import java.math.BigDecimal;
import java.time.Instant;

@Document(collection = "expenses")
public class ExpenseDocument {

    @Id
    private String id;
    private BigDecimal amount;
    private String description;
    private Instant date;
    private ExpenseCategory category;

    private String userId;

    public ExpenseDocument() {
    }

    public ExpenseDocument(String id,
                           BigDecimal amount,
                           String description,
                           Instant date,
                           ExpenseCategory category,
                           String userId) {
        this.id = id;
        this.amount = amount;
        this.description = description;
        this.date = date;
        this.category = category;
        this.userId = userId;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Instant getDate() {
        return date;
    }

    public void setDate(Instant date) {
        this.date = date;
    }

    public ExpenseCategory getCategory() {
        return category;
    }

    public void setCategory(ExpenseCategory category) {
        this.category = category;
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }
}

