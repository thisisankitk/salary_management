require "rails_helper"

RSpec.describe SalaryInsights::SummaryQuery do
  describe ".call" do
    before do
      create(
        :employee,
        full_name: "India Engineer One",
        country: "India",
        job_title: "Software Engineer",
        salary: 1_000_000
      )

      create(
        :employee,
        full_name: "India Engineer Two",
        country: "India",
        job_title: "Software Engineer",
        salary: 2_000_000
      )

      create(
        :employee,
        full_name: "India Product Manager",
        country: "India",
        job_title: "Product Manager",
        salary: 3_000_000
      )

      create(
        :employee,
        full_name: "US Engineer",
        country: "United States",
        job_title: "Software Engineer",
        salary: 4_000_000
      )
    end

    it "returns overall salary summary when no filters are provided" do
      result = described_class.call

      expect(result).to eq(
        filters: {},
        summary: {
          employee_count: 4,
          minimum_salary: "1000000.0",
          maximum_salary: "4000000.0",
          average_salary: "2500000.0"
        }
      )
    end

    it "returns salary summary filtered by country" do
      result = described_class.call(country: "India")

      expect(result).to eq(
        filters: {
          country: "India"
        },
        summary: {
          employee_count: 3,
          minimum_salary: "1000000.0",
          maximum_salary: "3000000.0",
          average_salary: "2000000.0"
        }
      )
    end

    it "returns salary summary filtered by job title" do
      result = described_class.call(job_title: "Software Engineer")

      expect(result).to eq(
        filters: {
          job_title: "Software Engineer"
        },
        summary: {
          employee_count: 3,
          minimum_salary: "1000000.0",
          maximum_salary: "4000000.0",
          average_salary: "2333333.33"
        }
      )
    end

    it "returns salary summary filtered by country and job title" do
      result = described_class.call(country: "India", job_title: "Software Engineer")

      expect(result).to eq(
        filters: {
          country: "India",
          job_title: "Software Engineer"
        },
        summary: {
          employee_count: 2,
          minimum_salary: "1000000.0",
          maximum_salary: "2000000.0",
          average_salary: "1500000.0"
        }
      )
    end

    it "returns zero summary when no employees match filters" do
      result = described_class.call(country: "Germany", job_title: "Designer")

      expect(result).to eq(
        filters: {
          country: "Germany",
          job_title: "Designer"
        },
        summary: {
          employee_count: 0,
          minimum_salary: nil,
          maximum_salary: nil,
          average_salary: nil
        }
      )
    end

    it "ignores blank filters" do
      result = described_class.call(country: "", job_title: nil)

      expect(result).to eq(
        filters: {},
        summary: {
          employee_count: 4,
          minimum_salary: "1000000.0",
          maximum_salary: "4000000.0",
          average_salary: "2500000.0"
        }
      )
    end
  end
end
