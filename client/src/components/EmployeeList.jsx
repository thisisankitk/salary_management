import { useCallback, useEffect, useState } from "react";
import { employeesApi } from "../api/employees";
import EmployeeForm from "./EmployeeForm";

function EmployeeList() {
  const [employees, setEmployees] = useState([]);
  const [meta, setMeta] = useState(null);
  const [page, setPage] = useState(1);
  const [refreshToken, setRefreshToken] = useState(0);
  const [status, setStatus] = useState("idle");
  const [errorMessage, setErrorMessage] = useState("");
  const [deletingEmployeeId, setDeletingEmployeeId] = useState(null);

  const loadEmployees = useCallback(async () => {
    try {
      setStatus("loading");
      setErrorMessage("");

      const response = await employeesApi.list({
        page,
        perPage: 10,
      });

      setEmployees(response.data);
      setMeta(response.meta);
      setStatus("success");
    } catch (error) {
      setStatus("error");
      setErrorMessage(error.message);
    }
  }, [page]);

  useEffect(() => {
    loadEmployees();
  }, [loadEmployees, refreshToken]);

  function refreshEmployees() {
    setRefreshToken((currentValue) => currentValue + 1);
  }

  function handleEmployeeCreated() {
    setPage(1);
    refreshEmployees();
  }

  async function handleDelete(employee) {
    const confirmed = window.confirm(
      `Delete ${employee.full_name}? This action cannot be undone.`
    );

    if (!confirmed) return;

    try {
      setDeletingEmployeeId(employee.id);
      setErrorMessage("");

      await employeesApi.remove(employee.id);

      if (employees.length === 1 && page > 1) {
        setPage((currentPage) => currentPage - 1);
      } else {
        refreshEmployees();
      }
    } catch (error) {
      setStatus("error");
      setErrorMessage(error.message);
    } finally {
      setDeletingEmployeeId(null);
    }
  }

  const isLoading = status === "loading";
  const isError = status === "error";

  return (
    <>
      <EmployeeForm onEmployeeCreated={handleEmployeeCreated} />

      <section className="card">
        <div className="section-header">
          <div>
            <h2>Employees</h2>
            <p>View employee salary records from the Rails API.</p>
          </div>

          {meta && (
            <span className="meta-pill">{meta.total_count} total employees</span>
          )}
        </div>

        {isLoading && <p className="notice">Loading employees...</p>}

        {isError && (
          <p className="error-message">
            Failed to load employees: {errorMessage}
          </p>
        )}

        {!isLoading && !isError && (
          <>
            <div className="table-wrapper">
              <table>
                <thead>
                  <tr>
                    <th>Name</th>
                    <th>Job Title</th>
                    <th>Country</th>
                    <th>Department</th>
                    <th>Salary</th>
                    <th>Employment Type</th>
                    <th>Actions</th>
                  </tr>
                </thead>

                <tbody>
                  {employees.map((employee) => (
                    <tr key={employee.id}>
                      <td>{employee.full_name}</td>
                      <td>{employee.job_title}</td>
                      <td>{employee.country}</td>
                      <td>{employee.department}</td>
                      <td>
                        {employee.currency}{" "}
                        {Number(employee.salary).toLocaleString()}
                      </td>
                      <td>{employee.employment_type.replaceAll("_", " ")}</td>
                      <td>
                        <button
                          type="button"
                          className="danger-button"
                          disabled={deletingEmployeeId === employee.id}
                          onClick={() => handleDelete(employee)}
                        >
                          {deletingEmployeeId === employee.id
                            ? "Deleting..."
                            : "Delete"}
                        </button>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>

            {meta && (
              <div className="pagination">
                <button
                  type="button"
                  disabled={page <= 1}
                  onClick={() => setPage((currentPage) => currentPage - 1)}
                >
                  Previous
                </button>

                <span>
                  Page {meta.current_page} of {meta.total_pages}
                </span>

                <button
                  type="button"
                  disabled={page >= meta.total_pages}
                  onClick={() => setPage((currentPage) => currentPage + 1)}
                >
                  Next
                </button>
              </div>
            )}
          </>
        )}
      </section>
    </>
  );
}

export default EmployeeList;