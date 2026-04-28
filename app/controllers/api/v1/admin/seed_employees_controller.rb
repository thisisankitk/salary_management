module Api
  module V1
    module Admin
      class SeedEmployeesController < ApplicationController
        def create
          return render_unauthorized unless valid_seed_token?

          result = Seeders::EmployeeSeeder.call(
            employee_count: seed_count,
            batch_size: batch_size
          )

          render json: {
            message: "Employees seeded successfully",
            employee_count: result.employee_count,
            elapsed_time: result.elapsed_time.round(2)
          }, status: :ok
        end

        private

        def valid_seed_token?
          expected_token = ENV["SEED_TOKEN"]
          provided_token = request.headers["X-Seed-Token"]

          expected_token.present? &&
            provided_token.present? &&
            ActiveSupport::SecurityUtils.secure_compare(provided_token, expected_token)
        end

        def seed_count
          ENV.fetch("EMPLOYEE_SEED_COUNT", Seeders::EmployeeSeeder::DEFAULT_EMPLOYEE_COUNT).to_i
        end

        def batch_size
          ENV.fetch("EMPLOYEE_SEED_BATCH_SIZE", Seeders::EmployeeSeeder::DEFAULT_BATCH_SIZE).to_i
        end

        def render_unauthorized
          render json: { error: "Unauthorized" }, status: :unauthorized
        end
      end
    end
  end
end