class UserRoleVenuesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_venue
  before_action :check_user_role_venue_existed, only: :create
  before_action :check_params_q, only: :create
  load_and_authorize_resource param_method: :user_role_params

  def index
    @user_roles = @venue.user_role_venues
    @current_user_role_venue = current_user.user_role_venues.find_by venue_id: @venue.id
  end

  def new
    @user_role_venue = UserRoleVenue.new
    respond_to do |format|
      @q = User.search params[:q]
      @users_search = @q.result
      format.html
      format.js
    end
  end

  def create
    @user_role_venue = @venue.user_role_venues.new user_role_params
    if @user_role_venue.save
      flash[:success] = t ".create_success"
      redirect_to venue_user_role_venues_path
    else
      flash[:danger] = t ".create_fail"
      render :new
    end
  end

  def edit
  end

  def update
    if load_change_role? && @user_role_venue.user == current_user
      flash[:danger] = t ".change_role_fail"
      render :edit
    elsif @user_role_venue.update_attributes user_role_params
      flash[:success] = t ".updated"
      redirect_to venue_user_role_venues_path
    else
      flash[:danger] = t ".update_fail"
      render :edit
    end
  end

  def destroy
    @user_role_venue.destroy
    respond_to do |format|
      format.js
    end
  end

  private
  def load_venue
    @venue = Venue.find_by id: params[:venue_id]
    unless @venue
      flash[:danger] = t "venues.not_found"
      redirect_to venues_path
    end
  end

  def user_role_params
    params.require(:user_role_venue).permit(:user_id, :type_role, :venue_id).merge old_owner: current_user
  end

  def check_user_role_venue_existed
    @user_role = @venue.user_role_venues.find_of_user params[:user_role_venue][:user_id]
    if @user_role.any?
      flash[:danger] = t ".existed"
      redirect_to venue_user_role_venues_path
    end
  end

  def user_role_venue_params
    params[:user_role_venue][:type_role]
  end

  def load_change_role?
    @count_owner_role = UserRoleVenue.find_owner_role_venue(@venue.id).length
    @count_owner_role.equal?(Settings.owner_count) &&
      user_role_venue_params != Settings.owner
  end

  def check_params_q
    unless user_role_params[:type_role].present? && user_role_params[:user_id].present?
      flash[:danger] = t ".need_info"
      redirect_to new_venue_user_role_venue_path(@venue)
    end
  end
end
