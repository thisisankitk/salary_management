# frozen_string_literal: true

require "benchmark"
module Seeders
  class EmployeeSeeder
    DEFAULT_EMPLOYEE_COUNT = 10_000
    DEFAULT_BATCH_SIZE = 1_000
    RANDOM_SEED = 42

    Result = Struct.new(:employee_count, :elapsed_time, keyword_init: true)

    def self.call(
      employee_count: DEFAULT_EMPLOYEE_COUNT,
      batch_size: DEFAULT_BATCH_SIZE,
      seed_data_path: Rails.root.join("db", "seed_data")
    )
      new(
        employee_count: employee_count,
        batch_size: batch_size,
        seed_data_path: seed_data_path
      ).call
    end

    def initialize(employee_count:, batch_size:, seed_data_path:)
      @employee_count = employee_count.to_i
      @batch_size = batch_size.to_i
      @seed_data_path = Pathname(seed_data_path)
    end

    def call
      validate_configuration!

      elapsed_time = Benchmark.realtime do
        Employee.transaction do
          Employee.delete_all

          employee_count.times.each_slice(batch_size) do |indexes|
            records = build_records(indexes)

            validate_batch!(records)

            Employee.insert_all!(records)
          end
        end
      end

      actual_count = Employee.count

      if actual_count != employee_count
        raise "Seed completed with unexpected employee count. Expected #{employee_count}, got #{actual_count}"
      end

      Result.new(employee_count: actual_count, elapsed_time: elapsed_time)
    end

    private

    attr_reader :employee_count, :batch_size, :seed_data_path

    def validate_configuration!
      raise "EMPLOYEE_SEED_COUNT must be greater than 0" unless employee_count.positive?
      raise "EMPLOYEE_SEED_BATCH_SIZE must be greater than 0" unless batch_size.positive?
      raise "Employee employment types must be configured" if employment_types.blank?
    end

    def build_records(indexes)
      now = Time.current
      random = Random.new(RANDOM_SEED + indexes.first)

      indexes.map do |index|
        country, currency = countries.sample(random: random)
        first_name = first_names[index % first_names.length]
        last_name = last_names[(index / first_names.length) % last_names.length]

        {
          full_name: "#{first_name} #{last_name}",
          job_title: job_titles.sample(random: random),
          country: country,
          salary: random.rand(salary_ranges.fetch(country)),
          currency: currency,
          department: departments.sample(random: random),
          employment_type: employment_types.sample(random: random),
          hired_on: random.rand(5.years).seconds.ago.to_date,
          created_at: now,
          updated_at: now
        }
      end
    end

    def validate_batch!(records)
      required_keys = %i[
        full_name
        job_title
        country
        salary
        currency
        department
        employment_type
        hired_on
        created_at
        updated_at
      ]

      records.each_with_index do |record, index|
        missing_keys = required_keys.select { |key| record[key].blank? }

        if missing_keys.any?
          raise "Invalid seed record at batch index #{index}. Missing: #{missing_keys.join(', ')}"
        end

        raise "Invalid salary at batch index #{index}" unless record[:salary].to_i.positive?

        unless employment_types.include?(record[:employment_type])
          raise "Invalid employment type at batch index #{index}: #{record[:employment_type]}"
        end
      end
    end

    def first_names
      @first_names ||= load_seed_values("first_names.txt")
    end

    def last_names
      @last_names ||= load_seed_values("last_names.txt")
    end

    def load_seed_values(file_name)
      path = seed_data_path.join(file_name)

      values = File.readlines(path, chomp: true)
        .map(&:strip)
        .reject(&:blank?)

      raise "#{file_name} must contain at least one value" if values.empty?

      values
    end

    def job_titles
      [
        "Software Engineer",
        "Senior Software Engineer",
        "Engineering Manager",
        "Product Manager",
        "Data Analyst",
        "QA Engineer",
        "DevOps Engineer",
        "HR Manager",
        "Finance Manager",
        "UX Designer"
      ]
    end

    def countries
      [
        ["India", "INR"],
        ["United States", "USD"],
        ["United Kingdom", "GBP"],
        ["Germany", "EUR"],
        ["Canada", "CAD"]
      ]
    end

    def departments
      [
        "Engineering",
        "Product",
        "Design",
        "Human Resources",
        "Finance",
        "Operations"
      ]
    end

    def salary_ranges
      {
        "India" => 600_000..5_000_000,
        "United States" => 60_000..250_000,
        "United Kingdom" => 45_000..180_000,
        "Germany" => 50_000..190_000,
        "Canada" => 55_000..200_000
      }
    end

    def employment_types
      Employee::EMPLOYMENT_TYPES
    end
  end
end