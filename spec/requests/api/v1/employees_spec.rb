require "rails_helper"

RSpec.describe "Api::V1::Employees", type: :request do
  describe "GET /api/v1/employees" do
    it "returns employees ordered by newest first with pagination metadata" do
      older_employee = create(:employee, full_name: "Older Employee", created_at: 2.days.ago)
      newer_employee = create(:employee, full_name: "Newer Employee", created_at: 1.day.ago)

      get "/api/v1/employees"

      expect(response).to have_http_status(:ok)

      json_response = JSON.parse(response.body)

      expect(json_response["data"].size).to eq(2)
      expect(json_response["data"].first["id"]).to eq(newer_employee.id)
      expect(json_response["data"].second["id"]).to eq(older_employee.id)

      expect(json_response["meta"]).to include(
        "current_page" => 1,
        "per_page" => 25,
        "total_count" => 2,
        "total_pages" => 1
      )
    end

    it "paginates employees" do
      create_list(:employee, 3)

      get "/api/v1/employees", params: { page: 1, per_page: 2 }

      expect(response).to have_http_status(:ok)

      json_response = JSON.parse(response.body)

      expect(json_response["data"].size).to eq(2)
      expect(json_response["meta"]).to include(
        "current_page" => 1,
        "per_page" => 2,
        "total_count" => 3,
        "total_pages" => 2
      )
    end

    it "caps per_page to avoid returning too many records" do
      create_list(:employee, 3)

      get "/api/v1/employees", params: { per_page: 500 }

      expect(response).to have_http_status(:ok)

      json_response = JSON.parse(response.body)

      expect(json_response["meta"]["per_page"]).to eq(100)
    end
  end

  describe "GET /api/v1/employees/:id" do
    it "returns the requested employee" do
      employee = create(:employee, full_name: "Ankit Khandelwal")

      get "/api/v1/employees/#{employee.id}"

      expect(response).to have_http_status(:ok)

      json_response = JSON.parse(response.body)

      expect(json_response["id"]).to eq(employee.id)
      expect(json_response["full_name"]).to eq("Ankit Khandelwal")
    end

    it "returns not found when employee does not exist" do
      get "/api/v1/employees/999999"

      expect(response).to have_http_status(:not_found)

      json_response = JSON.parse(response.body)

      expect(json_response["error"]).to eq("Employee not found")
    end
  end

  describe "POST /api/v1/employees" do
    it "creates an employee with valid params" do
      valid_params = {
        employee: {
          full_name: "Priya Sharma",
          job_title: "Product Manager",
          country: "India",
          salary: 1_800_000,
          currency: "INR",
          department: "Product",
          employment_type: "full_time",
          hired_on: "2023-04-01"
        }
      }

      expect do
        post "/api/v1/employees", params: valid_params
      end.to change(Employee, :count).by(1)

      expect(response).to have_http_status(:created)

      json_response = JSON.parse(response.body)

      expect(json_response["full_name"]).to eq("Priya Sharma")
      expect(json_response["job_title"]).to eq("Product Manager")
      expect(json_response["country"]).to eq("India")
      expect(json_response["department"]).to eq("Product")
    end

    it "does not create an employee with invalid params" do
      invalid_params = {
        employee: {
          full_name: "",
          job_title: "Product Manager",
          country: "India",
          salary: nil,
          currency: "INR",
          department: "Product",
          employment_type: "full_time",
          hired_on: "2023-04-01"
        }
      }

      expect do
        post "/api/v1/employees", params: invalid_params
      end.not_to change(Employee, :count)

      expect(response).to have_http_status(:unprocessable_entity)

      json_response = JSON.parse(response.body)

      expect(json_response["errors"]).to include("Full name can't be blank")
      expect(json_response["errors"]).to include("Salary can't be blank")
    end
  end

  describe "PATCH /api/v1/employees/:id" do
    it "updates an employee with valid params" do
      employee = create(:employee, full_name: "Old Name", salary: 1_000_000)

      update_params = {
        employee: {
          full_name: "Updated Name",
          salary: 1_500_000
        }
      }

      patch "/api/v1/employees/#{employee.id}", params: update_params

      expect(response).to have_http_status(:ok)

      employee.reload

      expect(employee.full_name).to eq("Updated Name")
      expect(employee.salary).to eq(1_500_000)
    end

    it "does not update an employee with invalid params" do
      employee = create(:employee, full_name: "Valid Name")

      update_params = {
        employee: {
          full_name: ""
        }
      }

      patch "/api/v1/employees/#{employee.id}", params: update_params

      expect(response).to have_http_status(:unprocessable_entity)

      employee.reload

      expect(employee.full_name).to eq("Valid Name")
    end

    it "returns not found when updating a missing employee" do
      patch "/api/v1/employees/999999", params: {
        employee: {
          full_name: "Missing Employee"
        }
      }

      expect(response).to have_http_status(:not_found)

      json_response = JSON.parse(response.body)

      expect(json_response["error"]).to eq("Employee not found")
    end
  end

  describe "DELETE /api/v1/employees/:id" do
    it "deletes the employee" do
      employee = create(:employee)

      expect do
        delete "/api/v1/employees/#{employee.id}"
      end.to change(Employee, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end

    it "returns not found when deleting a missing employee" do
      delete "/api/v1/employees/999999"

      expect(response).to have_http_status(:not_found)

      json_response = JSON.parse(response.body)

      expect(json_response["error"]).to eq("Employee not found")
    end
  end
end