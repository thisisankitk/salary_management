module Api
  module V1
    class EmployeesController < ApplicationController
      include Paginatable

      before_action :set_employee, only: %i[show update destroy]

      def index
        employees_scope = Employee.order(created_at: :desc)
        employees = employees_scope.offset(pagination_offset).limit(per_page)

        render json: {
          data: EmployeeSerializer.collection(employees),
          meta: pagination_meta(employees_scope.count)
        }, status: :ok
      end

      def show
        render json: EmployeeSerializer.new(@employee).as_json, status: :ok
      end

      def create
        employee = Employee.new(employee_params)

        if employee.save
          render json: EmployeeSerializer.new(employee).as_json, status: :created
        else
          render_validation_errors(employee)
        end
      end

      def update
        if @employee.update(employee_params)
          render json: EmployeeSerializer.new(@employee).as_json, status: :ok
        else
          render_validation_errors(@employee)
        end
      end

      def destroy
        @employee.destroy!

        head :no_content
      end

      private

      def set_employee
        @employee = Employee.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Employee not found" }, status: :not_found
      end

      def employee_params
        params.require(:employee).permit(
          :full_name,
          :job_title,
          :country,
          :salary,
          :currency,
          :department,
          :employment_type,
          :hired_on
        )
      end

      def render_validation_errors(employee)
        render json: { errors: employee.errors.full_messages }, status: :unprocessable_content
      end
    end
  end
end