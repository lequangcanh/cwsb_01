class Admin::SupportsController < Admin::BaseController
  before_action :find_user, only: :create

  def index
    @users = User.all
  end

  def create
    @support = @user.supports.build
    @supports = Support.of_user params[:user_id]
    @from_admin = true
    respond_to do |format|
      format.js
    end
  end
end
