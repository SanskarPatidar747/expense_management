package com.example.expense.repository;

import com.example.expense.model.ExpenseDocument;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ExpenseRepository extends MongoRepository<ExpenseDocument, String>, ExpenseRepositoryCustom {
}

