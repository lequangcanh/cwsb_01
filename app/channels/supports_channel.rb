class SupportsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "user_#{params[:user_id]}_channel"
  end

  def unsubscribed
  end

  def send_message data
    find_user
    @user.supports.create! content: data["message"],
      from_admin: data["from_admin"]
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
