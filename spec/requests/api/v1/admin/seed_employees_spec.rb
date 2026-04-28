require "rails_helper"

RSpec.describe "Api::V1::Admin::SeedEmployees", type: :request do
  describe "POST /api/v1/admin/seed_employees" do
    around do |example|
      original_seed_token = ENV["SEED_TOKEN"]
      original_employee_seed_count = ENV["EMPLOYEE_SEED_COUNT"]
      original_employee_seed_batch_size = ENV["EMPLOYEE_SEED_BATCH_SIZE"]
      original_allow_destructive_seed = ENV["ALLOW_DESTRUCTIVE_SEED"]

      ENV["SEED_TOKEN"] = "test-seed-token"
      ENV["EMPLOYEE_SEED_COUNT"] = "4"
      ENV["EMPLOYEE_SEED_BATCH_SIZE"] = "2"
      ENV["ALLOW_DESTRUCTIVE_SEED"] = "true"

      example.run
    ensure
      ENV["SEED_TOKEN"] = original_seed_token
      ENV["EMPLOYEE_SEED_COUNT"] = original_employee_seed_count
      ENV["EMPLOYEE_SEED_BATCH_SIZE"] = original_employee_seed_batch_size
      ENV["ALLOW_DESTRUCTIVE_SEED"] = original_allow_destructive_seed
    end

    it "seeds employees when seed token is valid" do
      post "/api/v1/admin/seed_employees", headers: {
        "X-Seed-Token" => "test-seed-token"
      }

      expect(response).to have_http_status(:ok)

      json_response = JSON.parse(response.body)

      expect(json_response["message"]).to eq("Employees seeded successfully")
      expect(json_response["employee_count"]).to eq(4)
      expect(Employee.count).to eq(4)
    end

    it "returns unauthorized when seed token is missing" do
      post "/api/v1/admin/seed_employees"

      expect(response).to have_http_status(:unauthorized)

      json_response = JSON.parse(response.body)

      expect(json_response["error"]).to eq("Unauthorized")
    end

    it "returns unauthorized when seed token is invalid" do
      post "/api/v1/admin/seed_employees", headers: {
        "X-Seed-Token" => "wrong-token"
      }

      expect(response).to have_http_status(:unauthorized)
    end
  end
end