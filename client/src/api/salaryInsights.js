import { apiRequest } from "./client";

export const salaryInsightsApi = {
  summary({ country = "", jobTitle = "" } = {}) {
    const params = new URLSearchParams();

    if (country) params.append("country", country);
    if (jobTitle) params.append("job_title", jobTitle);

    const queryString = params.toString();
    const path = queryString
      ? `/api/v1/salary_insights?${queryString}`
      : "/api/v1/salary_insights";

    return apiRequest(path);
  },
};