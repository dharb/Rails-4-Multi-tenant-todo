class Api::V1::UsersController < ApplicationController
  before_action :authenticate_with_token!, only: [:update, :show, :index, :destroy]
  before_action :require_company!, only: [:create]

  def index
    render json: { users: current_company.users }
  end

  def create
    user = current_company.users.build(user_params)
    if user.save
      render json: user, status: 201, location: [:api, user]
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  def show
    render json: current_company.users.find(params[:id])
  end

  def update
    user = current_user
    if user.update(user_params)
      render json: user, status: 200, location: [:api, user]
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  def destroy
    current_user.destroy
    head 204
  end

  private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :encrypted_password, :provider, :uid, :auth_token, :name, :company_id)
    end
end
