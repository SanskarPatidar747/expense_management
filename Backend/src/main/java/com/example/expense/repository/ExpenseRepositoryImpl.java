package com.example.expense.repository;

import com.example.expense.dto.ExpenseFilter;
import com.example.expense.model.ExpenseDocument;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class ExpenseRepositoryImpl implements ExpenseRepositoryCustom {

    private final MongoTemplate mongoTemplate;

    public ExpenseRepositoryImpl(MongoTemplate mongoTemplate) {
        this.mongoTemplate = mongoTemplate;
    }

    @Override
    public List<ExpenseDocument> findByFilter(ExpenseFilter filter) {
        Query query = new Query();

        if (filter.userId() == null || filter.userId().isBlank()) {
            throw new IllegalArgumentException("userId is required to fetch expenses");
        }
        query.addCriteria(Criteria.where("userId").is(filter.userId()));

        filter.categoryOpt().ifPresent(category ->
                query.addCriteria(Criteria.where("category").is(category)));

        filter.startDateOpt().ifPresent(start ->
                query.addCriteria(Criteria.where("date").gte(start)));

        return mongoTemplate.find(query, ExpenseDocument.class);
    }
}

