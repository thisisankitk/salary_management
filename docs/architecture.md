# Architecture Notes

## Product Goal

Build a minimal but usable salary management system for an HR manager managing salary data for approximately 10,000 employees.

## Architecture Direction

The system will be built as:

- Ruby on Rails API backend
- PostgreSQL relational database
- React frontend
- RSpec test suite

## Core Domain

The primary domain entity is Employee.

An Employee will capture salary-related and HR-relevant information such as:

- full name
- job title
- country
- salary
- currency
- department
- employment type
- hired date

## API Design

The salary insights API will expose a single flexible endpoint:

```http
GET /api/v1/salary_insights
```

When no filters are provided, it returns overall salary insights.

Supported filters:

```text
country
job_title
```

Examples:

```http
GET /api/v1/salary_insights
GET /api/v1/salary_insights?country=India
GET /api/v1/salary_insights?job_title=Software Engineer
GET /api/v1/salary_insights?country=India&job_title=Software Engineer
```

This keeps the API reusable and easy to extend with future filters like department or employment type.

## Design Principles

- Keep controllers thin
- Use models for persistence and validations
- Use query objects for salary insights and reporting
- Prefer database-level aggregation for performance
- Keep tests fast, deterministic, and readable
- Make seed data generation re-runnable and performance-conscious