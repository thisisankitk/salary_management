import { apiRequest } from "./client";

export const employeeOptionsApi = {
  list() {
    return apiRequest("/api/v1/employee_options");
  },
};