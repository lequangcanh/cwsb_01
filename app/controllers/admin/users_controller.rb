class Admin::UsersController < Admin::BaseController
  def index
    @query_users = User.ransack params[:q]
    @users = @query_users.result
      .page(params[:page]).per Settings.admin.users.per_page
  end

  def update
    respond_to do |format|
      @user = User.find_by id: params[:id]
      pre_block_status = @user.block
      unless @user
        flash.now[:danger] = t "admin.users.user_not_found" 
        return
      end
      if @user.update_attributes user_params
        if block_status_changed? pre_block_status, @user.block
          process_change_block_status @user
          @status = Settings.admin.users.block
        else
          @status = Settings.admin.users.active
        end
        flash.now[:success] = t "admin.users.succ_update"
      else
        flash.now[:danger] = t "admin.users.fail_update"
      end
      format.js
    end
  end

  private
  def user_params
    params.require(:user).permit :active, :block
  end

  def block_status_changed? pre_block_status, current_block_status
    if pre_block_status == current_block_status
      return false
    else
      return true
    end
  end

  def process_change_block_status user
    if user.block?
      UserMailer.block_user(user).deliver_later
    else
      UserMailer.unblock_user(user).deliver_later
    end
  end
end
