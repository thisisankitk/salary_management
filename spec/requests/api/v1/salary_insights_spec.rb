require "rails_helper"

RSpec.describe "Api::V1::SalaryInsights", type: :request do
  describe "GET /api/v1/salary_insights" do
    before do
      create(
        :employee,
        country: "India",
        job_title: "Software Engineer",
        salary: 1_000_000
      )

      create(
        :employee,
        country: "India",
        job_title: "Software Engineer",
        salary: 2_000_000
      )

      create(
        :employee,
        country: "India",
        job_title: "Product Manager",
        salary: 3_000_000
      )

      create(
        :employee,
        country: "United States",
        job_title: "Software Engineer",
        salary: 4_000_000
      )
    end

    it "returns overall salary insights when no filters are provided" do
      get "/api/v1/salary_insights"

      expect(response).to have_http_status(:ok)

      json_response = JSON.parse(response.body)

      expect(json_response).to eq(
        "filters" => {},
        "summary" => {
          "employee_count" => 4,
          "minimum_salary" => "1000000.0",
          "maximum_salary" => "4000000.0",
          "average_salary" => "2500000.0"
        }
      )
    end

    it "returns salary insights filtered by country" do
      get "/api/v1/salary_insights", params: { country: "India" }

      expect(response).to have_http_status(:ok)

      json_response = JSON.parse(response.body)

      expect(json_response).to eq(
        "filters" => {
          "country" => "India"
        },
        "summary" => {
          "employee_count" => 3,
          "minimum_salary" => "1000000.0",
          "maximum_salary" => "3000000.0",
          "average_salary" => "2000000.0"
        }
      )
    end

    it "returns salary insights filtered by job title" do
      get "/api/v1/salary_insights", params: { job_title: "Software Engineer" }

      expect(response).to have_http_status(:ok)

      json_response = JSON.parse(response.body)

      expect(json_response).to eq(
        "filters" => {
          "job_title" => "Software Engineer"
        },
        "summary" => {
          "employee_count" => 3,
          "minimum_salary" => "1000000.0",
          "maximum_salary" => "4000000.0",
          "average_salary" => "2333333.33"
        }
      )
    end

    it "returns salary insights filtered by country and job title" do
      get "/api/v1/salary_insights", params: {
        country: "India",
        job_title: "Software Engineer"
      }

      expect(response).to have_http_status(:ok)

      json_response = JSON.parse(response.body)

      expect(json_response).to eq(
        "filters" => {
          "country" => "India",
          "job_title" => "Software Engineer"
        },
        "summary" => {
          "employee_count" => 2,
          "minimum_salary" => "1000000.0",
          "maximum_salary" => "2000000.0",
          "average_salary" => "1500000.0"
        }
      )
    end

    it "returns empty salary summary when no employees match filters" do
      get "/api/v1/salary_insights", params: {
        country: "Germany",
        job_title: "Designer"
      }

      expect(response).to have_http_status(:ok)

      json_response = JSON.parse(response.body)

      expect(json_response).to eq(
        "filters" => {
          "country" => "Germany",
          "job_title" => "Designer"
        },
        "summary" => {
          "employee_count" => 0,
          "minimum_salary" => nil,
          "maximum_salary" => nil,
          "average_salary" => nil
        }
      )
    end
  end
end