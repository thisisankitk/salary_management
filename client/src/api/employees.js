import { apiRequest } from "./client";

export const employeesApi = {
  list({ page = 1, perPage = 25 } = {}) {
    const params = new URLSearchParams({
      page,
      per_page: perPage,
    });

    return apiRequest(`/api/v1/employees?${params.toString()}`);
  },

  show(id) {
    return apiRequest(`/api/v1/employees/${id}`);
  },

  create(employee) {
    return apiRequest("/api/v1/employees", {
      method: "POST",
      body: JSON.stringify({ employee }),
    });
  },

  update(id, employee) {
    return apiRequest(`/api/v1/employees/${id}`, {
      method: "PATCH",
      body: JSON.stringify({ employee }),
    });
  },

  remove(id) {
    return apiRequest(`/api/v1/employees/${id}`, {
      method: "DELETE",
    });
  },
};