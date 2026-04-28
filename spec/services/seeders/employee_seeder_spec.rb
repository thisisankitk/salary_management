# frozen_string_literal: true

require "rails_helper"

RSpec.describe Seeders::EmployeeSeeder do
  describe ".call" do
    let(:seed_data_path) { Rails.root.join("tmp", "seed_spec_data") }

    before do
      FileUtils.mkdir_p(seed_data_path)
      File.write(seed_data_path.join("first_names.txt"), "Aarav\nPriya\n")
      File.write(seed_data_path.join("last_names.txt"), "Sharma\nPatel\n")
    end

    after do
      FileUtils.rm_rf(seed_data_path)
    end

    it "creates the requested number of employees" do
      result = described_class.call(
        employee_count: 4,
        batch_size: 2,
        seed_data_path: seed_data_path
      )

      expect(Employee.count).to eq(4)
      expect(result.employee_count).to eq(4)
      expect(result.elapsed_time).to be_a(Float)
    end

    it "generates full names by combining first and last name files" do
      described_class.call(
        employee_count: 4,
        batch_size: 2,
        seed_data_path: seed_data_path
      )

      expect(Employee.pluck(:full_name)).to contain_exactly(
        "Aarav Sharma",
        "Priya Sharma",
        "Aarav Patel",
        "Priya Patel"
      )
    end

    it "clears existing employees before seeding" do
      create(:employee, full_name: "Existing Employee")

      described_class.call(
        employee_count: 2,
        batch_size: 1,
        seed_data_path: seed_data_path
      )

      expect(Employee.count).to eq(2)
      expect(Employee.pluck(:full_name)).not_to include("Existing Employee")
    end

    it "raises an error when first names file has no usable values" do
      File.write(seed_data_path.join("first_names.txt"), "\n  \n")

      expect do
        described_class.call(
          employee_count: 2,
          batch_size: 1,
          seed_data_path: seed_data_path
        )
      end.to raise_error("first_names.txt must contain at least one value")
    end

    it "raises an error when last names file has no usable values" do
      File.write(seed_data_path.join("last_names.txt"), "\n  \n")

      expect do
        described_class.call(
          employee_count: 2,
          batch_size: 1,
          seed_data_path: seed_data_path
        )
      end.to raise_error("last_names.txt must contain at least one value")
    end

    it "raises an error when employee count is invalid" do
      expect do
        described_class.call(
          employee_count: 0,
          batch_size: 1,
          seed_data_path: seed_data_path
        )
      end.to raise_error("EMPLOYEE_SEED_COUNT must be greater than 0")
    end

    it "raises an error when batch size is invalid" do
      expect do
        described_class.call(
          employee_count: 2,
          batch_size: 0,
          seed_data_path: seed_data_path
        )
      end.to raise_error("EMPLOYEE_SEED_BATCH_SIZE must be greater than 0")
    end
  end
end