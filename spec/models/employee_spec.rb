require "rails_helper"

RSpec.describe Employee, type: :model do
  describe "validations" do
    subject(:employee) do
      described_class.new(
        full_name: "Test User",
        job_title: "Software Engineer",
        country: "India",
        salary: 2_500_000,
        currency: "INR",
        department: "Engineering",
        employment_type: "full_time",
        hired_on: Date.new(2022, 1, 10)
      )
    end

    it "is valid with all required attributes" do
      expect(employee).to be_valid
    end

    it "requires a full name" do
      employee.full_name = nil

      expect(employee).not_to be_valid
      expect(employee.errors[:full_name]).to include("can't be blank")
    end

    it "requires a job title" do
      employee.job_title = nil

      expect(employee).not_to be_valid
      expect(employee.errors[:job_title]).to include("can't be blank")
    end

    it "requires a country" do
      employee.country = nil

      expect(employee).not_to be_valid
      expect(employee.errors[:country]).to include("can't be blank")
    end

    it "requires a salary" do
      employee.salary = nil

      expect(employee).not_to be_valid
      expect(employee.errors[:salary]).to include("can't be blank")
    end

    it "requires salary to be greater than zero" do
      employee.salary = 0

      expect(employee).not_to be_valid
      expect(employee.errors[:salary]).to include("must be greater than 0")
    end

    it "requires a currency" do
      employee.currency = nil

      expect(employee).not_to be_valid
      expect(employee.errors[:currency]).to include("can't be blank")
    end

    it "requires a department" do
      employee.department = nil

      expect(employee).not_to be_valid
      expect(employee.errors[:department]).to include("can't be blank")
    end

    it "requires an employment type" do
      employee.employment_type = nil

      expect(employee).not_to be_valid
      expect(employee.errors[:employment_type]).to include("can't be blank")
    end

    it "allows only supported employment types" do
      employee.employment_type = "contractor_vendor"

      expect(employee).not_to be_valid
      expect(employee.errors[:employment_type]).to include("is not included in the list")
    end

    it "requires a hired date" do
      employee.hired_on = nil

      expect(employee).not_to be_valid
      expect(employee.errors[:hired_on]).to include("can't be blank")
    end
  end
end