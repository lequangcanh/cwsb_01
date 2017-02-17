class SupportsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_user_by_params_user_id

  def index
    user_unread_supports = @user.supports.user_unread
    make_read_all_supports user_unread_supports
    respond_to do |format|
      format.json {render json: {user_unread: 0}}
    end
  end

  private
  def find_user
    @user = User.find_by id: params[:user_id]
    unless @user
      flash[:danger] = t "admin.users.user_not_found"
      redirect_to root_path
    end
  end
end
