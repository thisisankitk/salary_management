import { useEffect, useState } from "react";
import { employeesApi } from "../api/employees";

const initialFormState = {
  full_name: "",
  job_title: "",
  country: "India",
  salary: "",
  currency: "INR",
  department: "Engineering",
  employment_type: "full_time",
  hired_on: "",
};

const countryCurrencyMap = {
  India: "INR",
  "United States": "USD",
  "United Kingdom": "GBP",
  Germany: "EUR",
  Canada: "CAD",
};

function normalizeEmployeeForForm(employee) {
  if (!employee) return initialFormState;

  return {
    full_name: employee.full_name || "",
    job_title: employee.job_title || "",
    country: employee.country || "India",
    salary: employee.salary || "",
    currency: employee.currency || "INR",
    department: employee.department || "Engineering",
    employment_type: employee.employment_type || "full_time",
    hired_on: employee.hired_on || "",
  };
}

function EmployeeForm({ selectedEmployee, onEmployeeSaved, onCancelEdit }) {
  const [formData, setFormData] = useState(initialFormState);
  const [status, setStatus] = useState("idle");
  const [errorMessage, setErrorMessage] = useState("");

  const isEditing = Boolean(selectedEmployee);
  const isSubmitting = status === "submitting";

  useEffect(() => {
    setFormData(normalizeEmployeeForForm(selectedEmployee));
    setStatus("idle");
    setErrorMessage("");
  }, [selectedEmployee]);

  function handleChange(event) {
    const { name, value } = event.target;

    setFormData((currentData) => {
      const updatedData = {
        ...currentData,
        [name]: value,
      };

      if (name === "country") {
        updatedData.currency = countryCurrencyMap[value] || currentData.currency;
      }

      return updatedData;
    });
  }

  async function handleSubmit(event) {
    event.preventDefault();

    try {
      setStatus("submitting");
      setErrorMessage("");

      const payload = {
        ...formData,
        salary: Number(formData.salary),
      };

      if (isEditing) {
        await employeesApi.update(selectedEmployee.id, payload);
      } else {
        await employeesApi.create(payload);
      }

      setFormData(initialFormState);
      setStatus("success");
      onEmployeeSaved();
    } catch (error) {
      setStatus("error");
      setErrorMessage(error.message);
    }
  }

  function handleCancel() {
    setFormData(initialFormState);
    setStatus("idle");
    setErrorMessage("");
    onCancelEdit();
  }

  return (
    <section className="card">
      <div className="section-header">
        <div>
          <h2>{isEditing ? "Edit Employee" : "Add Employee"}</h2>
          <p>
            {isEditing
              ? "Update salary and employee details."
              : "Create a new salary record for an employee."}
          </p>
        </div>
      </div>

      {status === "success" && (
        <p className="success-message">
          Employee {isEditing ? "updated" : "created"} successfully.
        </p>
      )}

      {status === "error" && (
        <p className="error-message">
          Failed to {isEditing ? "update" : "create"} employee: {errorMessage}
        </p>
      )}

      <form className="employee-form" onSubmit={handleSubmit}>
        <label>
          Full name
          <input
            name="full_name"
            value={formData.full_name}
            onChange={handleChange}
            required
          />
        </label>

        <label>
          Job title
          <input
            name="job_title"
            value={formData.job_title}
            onChange={handleChange}
            required
          />
        </label>

        <label>
          Country
          <select
            name="country"
            value={formData.country}
            onChange={handleChange}
            required
          >
            {Object.keys(countryCurrencyMap).map((country) => (
              <option key={country} value={country}>
                {country}
              </option>
            ))}
          </select>
        </label>

        <label>
          Salary
          <input
            name="salary"
            type="number"
            min="1"
            value={formData.salary}
            onChange={handleChange}
            required
          />
        </label>

        <label>
          Currency
          <input
            name="currency"
            value={formData.currency}
            onChange={handleChange}
            required
          />
        </label>

        <label>
          Department
          <select
            name="department"
            value={formData.department}
            onChange={handleChange}
            required
          >
            <option value="Engineering">Engineering</option>
            <option value="Product">Product</option>
            <option value="Design">Design</option>
            <option value="Human Resources">Human Resources</option>
            <option value="Finance">Finance</option>
            <option value="Operations">Operations</option>
          </select>
        </label>

        <label>
          Employment type
          <select
            name="employment_type"
            value={formData.employment_type}
            onChange={handleChange}
            required
          >
            <option value="full_time">Full time</option>
            <option value="part_time">Part time</option>
            <option value="contract">Contract</option>
            <option value="intern">Intern</option>
          </select>
        </label>

        <label>
          Hired on
          <input
            name="hired_on"
            type="date"
            value={formData.hired_on}
            onChange={handleChange}
            required
          />
        </label>

        <div className="form-actions">
          {isEditing && (
            <button type="button" className="secondary-button" onClick={handleCancel}>
              Cancel
            </button>
          )}

          <button type="submit" disabled={isSubmitting}>
            {isSubmitting
              ? isEditing
                ? "Updating..."
                : "Creating..."
              : isEditing
                ? "Update Employee"
                : "Create Employee"}
          </button>
        </div>
      </form>
    </section>
  );
}

export default EmployeeForm;