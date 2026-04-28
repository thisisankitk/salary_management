import { useEffect, useState } from "react";
import { salaryInsightsApi } from "../api/salaryInsights";

const countries = [
  "",
  "India",
  "United States",
  "United Kingdom",
  "Germany",
  "Canada",
];

const jobTitles = [
  "",
  "Software Engineer",
  "Senior Software Engineer",
  "Engineering Manager",
  "Product Manager",
  "Data Analyst",
  "QA Engineer",
  "DevOps Engineer",
  "HR Manager",
  "Finance Manager",
  "UX Designer",
];

function formatSalary(value) {
  if (value === null || value === undefined) return "N/A";

  return Number(value).toLocaleString();
}

function SalaryInsights() {
  const [filters, setFilters] = useState({
    country: "",
    jobTitle: "",
  });
  const [insights, setInsights] = useState(null);
  const [status, setStatus] = useState("idle");
  const [errorMessage, setErrorMessage] = useState("");

  useEffect(() => {
    async function loadInsights() {
      try {
        setStatus("loading");
        setErrorMessage("");

        const response = await salaryInsightsApi.summary(filters);

        setInsights(response);
        setStatus("success");
      } catch (error) {
        setStatus("error");
        setErrorMessage(error.message);
      }
    }

    loadInsights();
  }, [filters]);

  function handleChange(event) {
    const { name, value } = event.target;

    setFilters((currentFilters) => ({
      ...currentFilters,
      [name]: value,
    }));
  }

  const isLoading = status === "loading";
  const isError = status === "error";
  const summary = insights?.summary;

  return (
    <section className="card">
      <div className="section-header">
        <div>
          <h2>Salary Insights</h2>
          <p>
            Explore minimum, maximum, and average salary using country and job
            title filters.
          </p>
        </div>
      </div>

      <div className="filters-grid">
        <label>
          Country
          <select name="country" value={filters.country} onChange={handleChange}>
            {countries.map((country) => (
              <option key={country || "all-countries"} value={country}>
                {country || "All countries"}
              </option>
            ))}
          </select>
        </label>

        <label>
          Job title
          <select
            name="jobTitle"
            value={filters.jobTitle}
            onChange={handleChange}
          >
            {jobTitles.map((jobTitle) => (
              <option key={jobTitle || "all-job-titles"} value={jobTitle}>
                {jobTitle || "All job titles"}
              </option>
            ))}
          </select>
        </label>
      </div>

      {isLoading && <p className="notice">Loading salary insights...</p>}

      {isError && (
        <p className="error-message">
          Failed to load salary insights: {errorMessage}
        </p>
      )}

      {!isLoading && !isError && summary && (
        <>
          <div className="insight-grid">
            <article className="insight-card">
              <span>Employees</span>
              <strong>{summary.employee_count}</strong>
            </article>

            <article className="insight-card">
              <span>Minimum Salary</span>
              <strong>{formatSalary(summary.minimum_salary)}</strong>
            </article>

            <article className="insight-card">
              <span>Maximum Salary</span>
              <strong>{formatSalary(summary.maximum_salary)}</strong>
            </article>

            <article className="insight-card">
              <span>Average Salary</span>
              <strong>{formatSalary(summary.average_salary)}</strong>
            </article>
          </div>

          {summary.employee_count === 0 && (
            <p className="notice">
              No employees found for the selected filters.
            </p>
          )}
        </>
      )}
    </section>
  );
}

export default SalaryInsights;