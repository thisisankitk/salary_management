# Deployment Notes

## Deployment Overview

This project is deployed as two separate applications from the same GitHub repository.

```text
salary_management/
  app/       Rails API backend
  config/    Rails configuration
  db/        Database migrations and seed data
  client/    React/Vite frontend
```

## Deployed Services

### Backend API

Hosted on Render.

[salary-management-api-mjdq.onrender.com](https://salary-management-api-mjdq.onrender.com)

### Frontend UI

Hosted on Vercel.

[salary-management-amber.vercel.app](https://salary-management-amber.vercel.app/)

## Why Backend and Frontend Are Deployed Separately

The repository contains both backend and frontend code, but they are deployed separately:

- Render deploys the Rails API from the repository root.
- Vercel deploys the React frontend from the `client/` directory.

This keeps the Rails API and React UI independently deployable while still keeping the assignment code in a single repository.

## Backend Deployment: Render

### Render Service Type

Web Service

### Runtime

Ruby

### Build Command

```bash
./bin/render-build.sh
```

### Start Command

```bash
bundle exec puma -C config/puma.rb
```

### Health Check Path

```text
/up
```

### Backend Environment Variables

```text
RAILS_ENV=production
RACK_ENV=production
DATABASE_URL=<Render PostgreSQL Internal Database URL>
RAILS_MASTER_KEY=<Rails master key>
FRONTEND_ORIGIN=<Vercel frontend URL>
WEB_CONCURRENCY=1
```

### Build Script

Render uses:

```text
bin/render-build.sh
```

The script installs dependencies and runs database migrations:

```bash
#!/usr/bin/env bash
set -o errexit

bundle install
bundle exec rails db:migrate
```

Seed data is intentionally not run during every deployment.

## Database Deployment: Render PostgreSQL

The production database is hosted using Render PostgreSQL.

The Rails backend connects using:

```text
DATABASE_URL
```

In `config/database.yml`, production database configuration uses the Render-provided `DATABASE_URL`.

## Frontend Deployment: Vercel

### Vercel Project Settings

```text
Framework Preset: Vite
Root Directory: client
Install Command: npm install
Build Command: npm run build
Output Directory: dist
```

### Frontend Environment Variables

```text
VITE_API_BASE_URL=https://salary-management-api-mjdq.onrender.com
```

This allows the React frontend to call the deployed Rails API.

## CORS Configuration

The Rails API uses CORS to allow browser requests from the deployed frontend origin.

Render environment variable:

```text
FRONTEND_ORIGIN=<Vercel frontend URL>
```

Example:

```text
FRONTEND_ORIGIN=https://salary-management.vercel.app
```

The value should not include a trailing slash.

## Production Seed Data

The application includes a performant employee seed process using:

- `Seeders::EmployeeSeeder`
- `insert_all!`
- batch inserts
- transaction safety
- source name files from `db/seed_data/first_names.txt` and `db/seed_data/last_names.txt`

By default, it creates 10,000 employees.

## Protected Seed Endpoint

Render free instances do not provide shell access. To support assignment/demo setup without upgrading the Render instance, a protected seed endpoint is available.

```text
POST /api/v1/admin/seed_employees
```

The endpoint requires a secret token through the request header:

```text
X-Seed-Token: <seed-token>
```

The token is configured only in Render environment variables:

```text
SEED_TOKEN=<secure-random-token>
```

The endpoint also requires destructive seeding to be explicitly enabled:

```text
ALLOW_DESTRUCTIVE_SEED=true
```

## Triggering Production Seed

```bash
curl -i -X POST https://salary-management-api-mjdq.onrender.com/api/v1/admin/seed_employees \
  -H "X-Seed-Token: <SEED_TOKEN>"
```

Expected response:

```json
{
  "message": "Employees seeded successfully",
  "employee_count": 10000,
  "elapsed_time": 1.23
}
```

After seeding, `ALLOW_DESTRUCTIVE_SEED` can be removed or set to `false` to prevent accidental reseeding.

## Deployment Verification

### Backend Health Check

```bash
curl -i https://salary-management-api-mjdq.onrender.com/up
```

Expected:

```text
HTTP 200
```

### Employee API

```bash
curl -i https://salary-management-api-mjdq.onrender.com/api/v1/employees
```

### Salary Insights API

```bash
curl -i https://salary-management-api-mjdq.onrender.com/api/v1/salary_insights
```

### CORS Check

```bash
curl -i \
  -H "Origin: <Vercel frontend URL>" \
  "https://salary-management-api-mjdq.onrender.com/api/v1/employees?page=1&per_page=10"
```

Expected response should include:

```text
access-control-allow-origin: <Vercel frontend URL>
```

## Free-Tier Notes

This assignment deployment uses free-tier services.

Important limitations:

- Render free web services may sleep after inactivity.
- First request after sleep can be slow.
- Render free instance does not support shell access.
- The protected seed endpoint was added to support demo seeding without upgrading the instance.

For a real production HR/salary system, a paid instance, proper authentication, monitoring, and managed database backups should be used.
