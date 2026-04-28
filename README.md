# Salary Management System

A salary management tool for HR managers to manage employees and view salary insights across countries and job titles.

## Assessment Focus

This project is built for an engineering assessment that evaluates:

- structured problem solving
- product thinking
- clean architecture
- test-driven development
- performance-aware implementation
- AI-assisted development with engineering ownership

## Tech Stack

### Backend

- Ruby on Rails API
- PostgreSQL
- RSpec
- FactoryBot

### Frontend

- React

## Planned Features

### Employee Management

- Add employees
- View employees
- Update employees
- Delete employees

### Salary Insights

The salary insights API will be designed as a flexible filtered endpoint:

```
GET /api/v1/salary_insights

Supported filters:
- country
- job_title

Example queries:
GET /api/v1/salary_insights
GET /api/v1/salary_insights?country=India
GET /api/v1/salary_insights?job_title=Software Engineer
GET /api/v1/salary_insights?country=India&job_title=Software Engineer
```
The endpoint will support:

- Minimum salary
- Maximum salary
- Average salary
- Employee count

### Seeding

- Generate 10,000 employees
- Use first_names.txt and last_names.txt
- Use performance-conscious bulk inserts