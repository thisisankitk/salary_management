require "rails_helper"

RSpec.describe "Api::V1::EmployeeOptions", type: :request do
  describe "GET /api/v1/employee_options" do
    it "returns distinct employee filter options" do
      create(
        :employee,
        country: "India",
        job_title: "Software Engineer",
        department: "Engineering",
        employment_type: "full_time"
      )

      create(
        :employee,
        country: "India",
        job_title: "Product Manager",
        department: "Product",
        employment_type: "full_time"
      )

      create(
        :employee,
        country: "Germany",
        job_title: "Software Engineer",
        department: "Engineering",
        employment_type: "contract"
      )

      get "/api/v1/employee_options"

      expect(response).to have_http_status(:ok)

      json_response = JSON.parse(response.body)

      expect(json_response).to eq(
        "countries" => ["Germany", "India"],
        "job_titles" => ["Product Manager", "Software Engineer"],
        "departments" => ["Engineering", "Product"],
        "employment_types" => ["contract", "full_time", "intern", "part_time"]
      )
    end
  end
end
