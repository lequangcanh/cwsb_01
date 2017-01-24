class Search::UsersController < ApplicationController
  def index
    respond_to do |format|
      @q = User.search params[:q]
      @users_search = @q.result
      format.html
      format.js
    end
  end
end
