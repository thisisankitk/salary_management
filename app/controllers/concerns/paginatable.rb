module Paginatable
  extend ActiveSupport::Concern

  DEFAULT_PAGE = 1
  DEFAULT_PER_PAGE = 25
  MAX_PER_PAGE = 100

  private

  def page
    value = params[:page].to_i
    value.positive? ? value : DEFAULT_PAGE
  end

  def per_page
    value = params[:per_page].to_i
    value = DEFAULT_PER_PAGE unless value.positive?

    [value, MAX_PER_PAGE].min
  end

  def pagination_offset
    (page - 1) * per_page
  end

  def pagination_meta(total_count)
    {
      current_page: page,
      per_page: per_page,
      total_count: total_count,
      total_pages: total_pages(total_count)
    }
  end

  def total_pages(total_count)
    (total_count.to_f / per_page).ceil
  end
end