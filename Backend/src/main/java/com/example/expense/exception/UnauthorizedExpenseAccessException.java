package com.example.expense.exception;

public class UnauthorizedExpenseAccessException extends RuntimeException {

    public UnauthorizedExpenseAccessException() {
        super("You do not have permission to access this expense");
    }
}



