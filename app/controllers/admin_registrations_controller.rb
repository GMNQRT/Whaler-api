class AdminRegistrationsController < ApplicationController
  before_action :authenticate_user_from_token!

  def index
    @users = User.all
    render json: @users
  end

  def show
    @user = User.find(params[:id])
    render json: @user
  end

  def create
    @user = User.new(user_params)
    if @user.save!
      render json: @user
    else
      render json: { error: flash[:error] }
    end
  end

  def update
    @user = User.find(params[:id])

    if @user.update!(user_params)
      render json: @user
    else
      render json: { error: flash[:error] }
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      flash[:notice] = "Successfully deleted User."
      render json: { notice: flash[:notice] }
    end
  end

  private

  def user_params
    params.require(:admin_registration).permit(:first_name, :last_name, :role, :email, :password, :created_at, :updated_at, :password_confirmation)
  end
end
