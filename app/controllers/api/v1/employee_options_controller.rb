module Api
  module V1
    class EmployeeOptionsController < ApplicationController
      def show
        render json: {
          countries: distinct_values(:country),
          job_titles: distinct_values(:job_title),
          departments: distinct_values(:department),
          employment_types: Employee::EMPLOYMENT_TYPES.sort
        }, status: :ok
      end

      private

      def distinct_values(column)
        Employee
          .where.not(column => [nil, ""])
          .distinct
          .order(column)
          .pluck(column)
      end
    end
  end
end