package com.example.expense.model;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonValue;

import java.util.Arrays;

public enum ExpenseCategory {
    FOOD("food", "Food & Dining"),
    TRANSPORT("transport", "Transport"),
    UTILITIES("utilities", "Utilities"),
    ENTERTAINMENT("entertainment", "Entertainment"),
    SHOPPING("shopping", "Shopping"),
    TRAVEL("travel", "Travel"),
    OTHER("other", "Other");

    private final String value;
    private final String label;

    ExpenseCategory(String value, String label) {
        this.value = value;
        this.label = label;
    }

    public String getLabel() {
        return label;
    }

    @JsonValue
    public String getValue() {
        return value;
    }

    @JsonCreator
    public static ExpenseCategory fromValue(String value) {
        if (value == null || value.isBlank()) {
            return OTHER;
        }
        return Arrays.stream(values())
                .filter(category -> category.value.equalsIgnoreCase(value.trim()))
                .findFirst()
                .orElse(OTHER);
    }
}

