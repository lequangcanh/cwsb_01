class SupportsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_user

  def index
    user_unread_supports = @user.supports.user_unread
    make_read_all_supports user_unread_supports
    respond_to do |format|
      format.json {render json: {user_unread: 0}}
    end
  end
end
