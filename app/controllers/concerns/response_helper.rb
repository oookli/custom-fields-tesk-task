module ResponseHelper
  def render_success_response(message, data, status = :ok)
    render json: {
      success: true,
      message: message,
      data: data
    }, status: status
  end

  def render_unprocessable_entity_response(error = 'Unprocessable entity')
    render json: {
      success: false,
      errors: error,
    }, status: :unprocessable_entity
  end

  # def render_unauthorized_response(message = 'Unauthorized')
  # end

  def render_not_found_response(message)
    render json: {
      success: false,
      message: message,
      data: nil
    }, status: :not_found
  end
end
