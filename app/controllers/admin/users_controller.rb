class Admin::UsersController < Admin::BaseController
  before_action :user_exists, only: :update

  def index
    @query_users = User.ransack params[:q]
    @users = @query_users.result
      .page(params[:page]).per Settings.admin.users.per_page
    get_number_users_by_status
    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
    respond_to do |format|
      if @user.update_attributes user_params
        get_number_users_by_status
        format.json {render json: {flash: t("admin.users.succ_update"), status: 200,
          total_active: @total_active, total_block: @total_block,
          total_reject: @total_reject}}
      else
        format.json {render json: {flash: t("admin.users.fail_update"), status: 400}}
      end
    end
  end

  private
  def user_params
    params.require(:user).permit :status
  end

  def user_exists
    @user = User.find_by id: params[:id]
    unless @user
      flash[:danger] = t "admin.users.user_not_found"
      redirect_to admin_users_path
    end
  end

  def number_users_by_status users
    users.count
  end

  def get_number_users_by_status
    @total_active = number_users_by_status User.active
    @total_block = number_users_by_status User.blocked
    @total_reject = number_users_by_status User.reject
  end
end
