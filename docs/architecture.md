# Architecture Notes

## Product Goal

Build a minimal but usable salary management system for an HR manager managing salary data for approximately 10,000 employees.

## User Persona

The primary user is an HR manager who needs to:

- maintain employee salary records
- view employees
- add new employees
- update employee information
- delete employees
- understand salary ranges and averages across countries and job titles

## Architecture Direction

The system is built as:

- Ruby on Rails API backend
- PostgreSQL relational database
- React frontend using Vite
- RSpec test suite

## Core Domain

The primary domain entity is `Employee`.

An employee captures:

- full name
- job title
- country
- salary
- currency
- department
- employment type
- hired date

The assignment required full name, job title, country, and salary. Additional fields were included to make the product more useful for HR workflows.

## API Design

### Employee Management

Employee CRUD is exposed through versioned REST endpoints:

```http
GET    /api/v1/employees
GET    /api/v1/employees/:id
POST   /api/v1/employees
PATCH  /api/v1/employees/:id
DELETE /api/v1/employees/:id
```

The employee list endpoint is paginated to avoid returning all records at once.

### Salary Insights

Salary insights use one flexible endpoint:

```http
GET /api/v1/salary_insights
```

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

This keeps the API reusable and easy to extend.

### Employee Options

The frontend needs filter dropdowns for countries and job titles.

Instead of hardcoding these values in React, the backend exposes:

```http
GET /api/v1/employee_options
```

This returns distinct values from the database and keeps the UI aligned with real data.

## Backend Design

### Controllers

Controllers are kept thin. They handle:

- HTTP params
- calling models/query objects/services
- rendering JSON responses

### Query Objects

Salary insights live in:

```text
SalaryInsights::SummaryQuery
```

This avoids placing reporting logic inside controllers or models.

### Services

Seed generation lives in:

```text
Seeders::EmployeeSeeder
```

This keeps `db/seeds.rb` small and makes seed behavior testable.

### Serializers

Employee JSON formatting lives in:

```text
EmployeeSerializer
```

This keeps the controller cleaner and centralizes response shape.

## Frontend Design

The React frontend is located in:

```text
client/
```

Frontend API calls are centralized in:

```text
client/src/api/
```

Components are located in:

```text
client/src/components/
```

This avoids scattering fetch logic throughout UI components.

## Design Principles

- Keep controllers thin
- Use models for persistence and validations
- Use query objects for reporting logic
- Use services for reusable operations
- Prefer database-level aggregation for performance
- Keep tests fast, deterministic, and readable
- Make seed data generation re-runnable and performance-conscious


## Security Considerations

The current implementation includes CORS configuration so the browser-based frontend can communicate with the Rails API from an allowed origin.

For a production HR/salary system, API authentication and authorization should be added before handling real salary data. A future enhancement would be to add HR/admin login, bearer-token or session-based authentication, role-based access control, and audit logging for sensitive actions.