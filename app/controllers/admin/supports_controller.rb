class Admin::SupportsController < Admin::BaseController
  before_action :find_user_by_params_user_id, only: :create

  def index
    @users = Support.latest_user_id.map {|id| User.find_by id: id}
  end

  def create
    @support = @user.supports.build
    admin_unread_supports = @user.supports.admin_unread
    make_read_all_supports admin_unread_supports
    @supports = Support.of_user params[:user_id]
    respond_to do |format|
      format.js
    end
  end
end
