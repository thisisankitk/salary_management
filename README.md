# Salary Management System

A salary management application for HR teams to manage employee salary records and view salary insights across countries and job titles.

## Features

### Employee Management

- Add employees
- View employees with pagination
- Update employee details
- Delete employees

### Salary Insights

- Employee count
- Minimum salary
- Maximum salary
- Average salary
- Filter insights by country
- Filter insights by job title
- Filter insights by country and job title together

### Seed Data

- Generates 10,000 employees by default
- Full names are generated from `first_names.txt` and `last_names.txt`
- Supports configurable employee count and batch size
- Uses bulk inserts for performance

## Tech Stack

### Backend

- Ruby on Rails API
- PostgreSQL
- RSpec
- FactoryBot

### Frontend

- React
- Vite
- Fetch API

## Project Structure

```text
salary_management/
  app/
    controllers/
    models/
    queries/
    serializers/
    services/
  client/
    src/
      api/
      components/
  db/
    seed_data/
  docs/
  spec/
```

## Backend Setup

Install dependencies:

```sh
bundle install
```

Create and migrate database:

```sh
rails db:create
rails db:migrate
```

Seed the database:

```sh
rails db:seed
```

By default, this creates 10,000 employees.

To seed a smaller dataset:

```sh
EMPLOYEE_SEED_COUNT=100 EMPLOYEE_SEED_BATCH_SIZE=25 rails db:seed
```

Run backend tests:

```sh
bundle exec rspec
```

Start Rails API server:

```sh
rails server
```

Backend runs at:

```text
http://localhost:3000
```

## Frontend Setup

Go to frontend directory:

```sh
cd client
```

Install dependencies:

```sh
npm install
```

Create local env file:

```sh
cp .env.example .env
```

Start frontend:

```sh
npm run dev
```

Frontend runs at:

```text
http://localhost:5173
```

Build frontend:

```sh
npm run build
```

## API Endpoints

### Employees

```text
GET    /api/v1/employees
GET    /api/v1/employees/:id
POST   /api/v1/employees
PATCH  /api/v1/employees/:id
DELETE /api/v1/employees/:id
```

### Salary Insights

```text
GET /api/v1/salary_insights
GET /api/v1/salary_insights?country=India
GET /api/v1/salary_insights?job_title=Software Engineer
GET /api/v1/salary_insights?country=India&job_title=Software Engineer
```

### Employee Options

```text
GET /api/v1/employee_options
```

Used by the frontend to populate dynamic filter dropdowns.

## Development Approach

The project was built incrementally with test-driven development.

The backend separates responsibilities using:

- Models for persistence and validations
- Controllers for HTTP request handling
- Query objects for salary insights
- Services for reusable seed generation
- Serializers for JSON response formatting

## Performance Considerations

- Employee listing uses pagination
- Salary insights use database-level aggregation
- Seed generation uses `insert_all!` in batches
- Seed operation is wrapped in a database transaction
- Indexes are added for country, job title, and country/job title filters
