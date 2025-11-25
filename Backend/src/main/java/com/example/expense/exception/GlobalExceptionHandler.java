package com.example.expense.exception;

import com.fasterxml.jackson.annotation.JsonFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.time.Instant;
import java.util.HashMap;
import java.util.Map;

@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(ExpenseNotFoundException.class)
    public ResponseEntity<ProblemDetailResponse> handleExpenseNotFound(ExpenseNotFoundException ex) {
        return ResponseEntity.status(HttpStatus.NOT_FOUND)
                .body(new ProblemDetailResponse(HttpStatus.NOT_FOUND.value(), ex.getMessage(), Map.of()));
    }

    @ExceptionHandler(UserAlreadyExistsException.class)
    public ResponseEntity<ProblemDetailResponse> handleUserExists(UserAlreadyExistsException ex) {
        return ResponseEntity.status(HttpStatus.CONFLICT)
                .body(new ProblemDetailResponse(HttpStatus.CONFLICT.value(), ex.getMessage(), Map.of()));
    }

    @ExceptionHandler(InvalidCredentialsException.class)
    public ResponseEntity<ProblemDetailResponse> handleInvalidCredentials(InvalidCredentialsException ex) {
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                .body(new ProblemDetailResponse(HttpStatus.UNAUTHORIZED.value(), ex.getMessage(), Map.of()));
    }

    @ExceptionHandler(UnauthorizedExpenseAccessException.class)
    public ResponseEntity<ProblemDetailResponse> handleUnauthorizedExpense(UnauthorizedExpenseAccessException ex) {
        return ResponseEntity.status(HttpStatus.FORBIDDEN)
                .body(new ProblemDetailResponse(HttpStatus.FORBIDDEN.value(), ex.getMessage(), Map.of()));
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ProblemDetailResponse> handleValidation(MethodArgumentNotValidException ex) {
        Map<String, String> errors = new HashMap<>();
        for (FieldError fieldError : ex.getBindingResult().getFieldErrors()) {
            errors.put(fieldError.getField(), fieldError.getDefaultMessage());
        }
        return ResponseEntity.badRequest()
                .body(new ProblemDetailResponse(HttpStatus.BAD_REQUEST.value(), "Validation failed", errors));
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ProblemDetailResponse> handleFallback(Exception ex) {
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(new ProblemDetailResponse(HttpStatus.INTERNAL_SERVER_ERROR.value(), ex.getMessage(), Map.of()));
    }

    public record ProblemDetailResponse(int status,
                                        String message,
                                        Map<String, String> details,
                                        @JsonFormat(shape = JsonFormat.Shape.STRING) Instant timestamp) {
        public ProblemDetailResponse(int status, String message, Map<String, String> details) {
            this(status, message, details, Instant.now());
        }
    }
}

