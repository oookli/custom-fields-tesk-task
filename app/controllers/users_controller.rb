# frozen_string_literal: true

class UsersController < ApplicationController
  before_action only: %i[update show destroy] do
    @user = User.find(params[:id])
  end

  def index
    render_success_response('All users', User.all)
  end

  def create
    created_user = User.create!(user_params)

    render_success_response('User created successfully', created_user, :created)
  end

  def update
    @user.update!(user_params)

    render_success_response('User updated successfully', @user)
  end

  def show
    render_success_response('Current user', @user)
  end

  def destroy
    @user.delete

    render_destroy_response
  end

  private

  def user_params
    params.require(:user).permit(:email)
  end
end
