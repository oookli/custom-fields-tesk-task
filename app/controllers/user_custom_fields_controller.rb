# frozen_string_literal: true

class UserCustomFieldsController < ApplicationController
  before_action only: %i[update destroy] do
    @user_custom_field = UserCustomField.find(params[:id])
  end

  def index
    render_success_response('All User custom fields', UserCustomField.all)
  end

  def create
    user_custom_field = UserCustomField.create!(user_custom_field_params)

    render_success_response('User custom field created successfully', user_custom_field, :created)
  end

  def update
    @user_custom_field.update!(user_custom_field_params)

    render_success_response('User custom field updated successfully', @user_custom_field)
  end

  def destroy
    @user_custom_field.delete

    render_destroy_response
  end

  private

  def user_custom_field_params
    params.require(:user_custom_field).permit(:name, :field_type, options: [])
  end
end
