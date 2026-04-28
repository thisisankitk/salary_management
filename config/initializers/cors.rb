# frozen_string_literal: true

allowed_origins = ENV.fetch("FRONTEND_ORIGIN", "http://localhost:5173")

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins allowed_origins

    resource "/api/*",
      headers: :any,
      methods: %i[get post put patch delete options head]
  end
end