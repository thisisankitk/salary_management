import { useEffect, useState } from "react";
import { employeesApi } from "../api/employees";

function EmployeeList() {
  const [employees, setEmployees] = useState([]);
  const [meta, setMeta] = useState(null);
  const [page, setPage] = useState(1);
  const [status, setStatus] = useState("idle");
  const [errorMessage, setErrorMessage] = useState("");

  useEffect(() => {
    async function loadEmployees() {
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
    }

    loadEmployees();
  }, [page]);

  const isLoading = status === "loading";
  const isError = status === "error";

  return (
    <section className="card">
      <div className="section-header">
        <div>
          <h2>Employees</h2>
          <p>View employee salary records from the Rails API.</p>
        </div>

        {meta && (
          <span className="meta-pill">
            {meta.total_count} total employees
          </span>
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
                      {employee.currency} {Number(employee.salary).toLocaleString()}
                    </td>
                    <td>{employee.employment_type.replaceAll("_", " ")}</td>
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
  );
}

export default EmployeeList;