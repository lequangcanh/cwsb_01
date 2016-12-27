class Admin::UsersController < Admin::BaseController
  def index
    @query_users = User.ransack params[:q]
    @users = @query_users.result
      .page(params[:page]).per Settings.admin.users.per_page
  end
end
