class UserCustomFieldsController < ApplicationController
  include ResponseHelper

  def create
    user_custom_field = UserCustomField.create(user_custom_field_params)

    if user_custom_field.valid?
      render_success_response('User custom field created successfully', user_custom_field, :created)
    else
      render_unprocessable_entity_response(user_custom_field.errors)
    end

  rescue ActionController::ParameterMissing => e
    render_unprocessable_entity_response(e.message)
  end

  private

  def user_custom_field_params
    params.require(:user_custom_field).permit(:name, :field_type)
  end
end
