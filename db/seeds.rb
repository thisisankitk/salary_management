# frozen_string_literal: true

require "benchmark"

employee_count = ENV.fetch(
  "EMPLOYEE_SEED_COUNT",
  Seeders::EmployeeSeeder::DEFAULT_EMPLOYEE_COUNT
).to_i

batch_size = ENV.fetch(
  "EMPLOYEE_SEED_BATCH_SIZE",
  Seeders::EmployeeSeeder::DEFAULT_BATCH_SIZE
).to_i

puts "Seeding #{employee_count} employees..."
puts "Batch size: #{batch_size}"

result = Seeders::EmployeeSeeder.call(
  employee_count: employee_count,
  batch_size: batch_size
)

puts "Seeded #{result.employee_count} employees in #{result.elapsed_time.round(2)} seconds."