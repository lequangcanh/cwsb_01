class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user

  def edit
    @user.build_image if @user.image.blank?
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "users.registrations.edit.success_update"
      redirect_to edit_user_path @user
    else
      flash[:danger] = @user.errors.full_messages
      redirect_to edit_user_path @user
    end
  end

  private
  def user_params
    params.require(:user).permit :name, :bio, :company, :address, :facebook,
      :google, :twitter, :phone_number, image_attributes: [:picture]
  end

  def correct_user
    @user = User.find_by id: params[:id]
    unless current_user.is_user? @user
      flash[:danger] = t "users.registrations.edit.not_permitted"
      redirect_to edit_user_path current_user
    end
  end
end
