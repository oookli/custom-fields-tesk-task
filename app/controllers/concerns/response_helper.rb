# frozen_string_literal: true

module ResponseHelper
  def render_success_response(message, data, status = :ok)
    render json: {
      success: true,
      message:,
      data:
    }, status:
  end

  def render_unprocessable_entity_response(error = 'Unprocessable entity', status = :unprocessable_entity)
    render json: {
      success: false,
      errors: error
    }, status:
  end

  def render_record_exists_response(error)
    render json: {
      success: false,
      errors: error
    }, status: :conflict
  end

  # def render_unauthorized_response(message = 'Unauthorized')
  # end

  def render_not_found_response(message)
    render json: {
      success: false,
      message:,
      data: nil
    }, status: :not_found
  end
end
