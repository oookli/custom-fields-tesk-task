# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ResponseHelper

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
  rescue_from ActiveRecord::RecordNotUnique, with: :record_exists
  rescue_from ActionController::ParameterMissing, with: :params_missing

  private

  def record_not_found(error)
    render_not_found_response(error.message)
  end

  def record_invalid(error)
    render_unprocessable_entity_response(error.message)
  end

  def record_exists(error)
    render_record_exists_response(error.message)
  end

  def params_missing(error)
    render_unprocessable_entity_response(error.message, :bad_request)
  end
end
