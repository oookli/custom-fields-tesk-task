# frozen_string_literal: true

class UserCustomFieldsController < ApplicationController
  def create
    user_custom_field = UserCustomField.create!(user_custom_field_params)

    render_success_response('User custom field created successfully', user_custom_field, :created)
  end

  private

  def user_custom_field_params
    params.require(:user_custom_field).permit(:name, :field_type)
  end
end
