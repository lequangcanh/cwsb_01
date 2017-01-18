class Admin::UsersController < Admin::BaseController
  before_action :user_exists, only: :update

  def index
    @query_users = User.ransack params[:q]
    @users = @query_users.result
      .page(params[:page]).per Settings.admin.users.per_page
    @total_active = total_status Settings.admin.users.active
    @total_block = total_status Settings.admin.users.blocked
    @total_reject = total_status Settings.admin.users.rejected

    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
    respond_to do |format|
      if @user.update_attributes user_params
        format.json {render json: {flash: t("admin.users.succ_update"), status: 200}}
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

  def total_status status
    User.send(status).count
  end
end
