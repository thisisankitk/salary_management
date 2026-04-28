import { useEffect, useState } from "react";
import { employeeOptionsApi } from "../api/employeeOptions";
import { salaryInsightsApi } from "../api/salaryInsights";

function formatSalary(value) {
  if (value === null || value === undefined) return "N/A";

  return Number(value).toLocaleString();
}

function SalaryInsights() {
  const [filters, setFilters] = useState({
    country: "",
    jobTitle: "",
  });

  const [options, setOptions] = useState({
    countries: [],
    job_titles: [],
  });

  const [insights, setInsights] = useState(null);
  const [status, setStatus] = useState("idle");
  const [optionsStatus, setOptionsStatus] = useState("idle");
  const [errorMessage, setErrorMessage] = useState("");

  useEffect(() => {
    async function loadOptions() {
      try {
        setOptionsStatus("loading");

        const response = await employeeOptionsApi.list();

        setOptions(response);
        setOptionsStatus("success");
      } catch (_error) {
        setOptionsStatus("error");
      }
    }

    loadOptions();
  }, []);

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
            <option value="">All countries</option>

            {options.countries.map((country) => (
              <option key={country} value={country}>
                {country}
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
            <option value="">All job titles</option>

            {options.job_titles.map((jobTitle) => (
              <option key={jobTitle} value={jobTitle}>
                {jobTitle}
              </option>
            ))}
          </select>
        </label>
      </div>

      {optionsStatus === "loading" && (
        <p className="notice">Loading filter options...</p>
      )}

      {optionsStatus === "error" && (
        <p className="notice">
          Filter options could not be loaded. Salary insights still work with
          default filters.
        </p>
      )}

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
            <p className="notice">No employees found for the selected filters.</p>
          )}
        </>
      )}
    </section>
  );
}

export default SalaryInsights;