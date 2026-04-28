class Employee < ApplicationRecord
    EMPLOYMENT_TYPES = %w[
    full_time
    part_time
    contract
    intern
  ].freeze

  validates :full_name, presence: true
  validates :job_title, presence: true
  validates :country, presence: true
  validates :salary, presence: true, numericality: { greater_than: 0 }
  validates :currency, presence: true
  validates :department, presence: true
  validates :employment_type, presence: true, inclusion: { in: EMPLOYMENT_TYPES }
  validates :hired_on, presence: true
end
