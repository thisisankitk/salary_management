module Api
  module V1
    class SalaryInsightsController < ApplicationController
      def show
        render json: SalaryInsights::SummaryQuery.call(
          country: params[:country],
          job_title: params[:job_title]
        ), status: :ok
      end
    end
  end
end