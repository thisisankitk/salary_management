module SalaryInsights
  class SummaryQuery
    def self.call(country: nil, job_title: nil)
      new(country: country, job_title: job_title).call
    end

    def initialize(country: nil, job_title: nil)
      @country = normalize_filter(country)
      @job_title = normalize_filter(job_title)
    end

    def call
      {
        filters: applied_filters,
        summary: salary_summary
      }
    end

    private

    attr_reader :country, :job_title

    def salary_summary
      employee_count, minimum_salary, maximum_salary, average_salary =
        filtered_scope.pick(
          Arel.sql("COUNT(*)"),
          Arel.sql("MIN(salary)"),
          Arel.sql("MAX(salary)"),
          Arel.sql("AVG(salary)")
        )

      {
        employee_count: employee_count,
        minimum_salary: format_decimal(minimum_salary),
        maximum_salary: format_decimal(maximum_salary),
        average_salary: format_decimal(average_salary)
      }
    end

    def filtered_scope
      scope = Employee.all
      scope = scope.where(country: country) if country.present?
      scope = scope.where(job_title: job_title) if job_title.present?
      scope
    end

    def applied_filters
      {}.tap do |filters|
        filters[:country] = country if country.present?
        filters[:job_title] = job_title if job_title.present?
      end
    end

    def normalize_filter(value)
      value.to_s.strip.presence
    end

    def format_decimal(value)
      return nil if value.nil?

      rounded_value = BigDecimal(value.to_s).round(2)

      if rounded_value.frac.zero?
        "#{rounded_value.to_i}.0"
      else
        rounded_value.to_s("F")
      end
    end
  end
end
