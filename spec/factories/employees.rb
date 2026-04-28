FactoryBot.define do
  factory :employee do
    full_name { Faker::Name.name }
    job_title { "Software Engineer" }
    country { "India" }
    salary { 2_500_000 }
    currency { "INR" }
    department { "Engineering" }
    employment_type { "full_time" }
    hired_on { Date.new(2022, 1, 10) }
  end
end
