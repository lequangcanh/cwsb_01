class ApplicationController < ActionController::Base
  require "tasks/payment_time"
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :load_notification
  before_action :set_locale
  before_action :load_support_messages
  before_action :load_notification_admin

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to :back, alert: exception.message
  end
  include PublicActivity::StoreController
  include GeneralHelper

  around_action :skip_bullet

  def skip_bullet
    Bullet.enable = false
    yield
  ensure
    Bullet.enable = true
  end

  def load_notification
    if user_signed_in?
      @notifications = Notification.by_receiver(current_user).newest
      @count_notification_unread = @notifications.unread.size
    end
  end

  def load_notification_admin
    if admin_signed_in?
      @notifications_admin = Notification.by_receiver(current_admin).limit(Settings.notification.limit).newest
      count_notification_unread_admin = @notifications_admin.unread.size   
    end
  end

  def after_sign_out_path_for resource
    return new_admin_session_path if resource == :admin
    return root_path if resource == :user
  end

  def load_support_messages
    if user_signed_in?
      @support = current_user.supports.build
      @supports = current_user.supports.all
      @from_admin = false
    end
  end

  def find_user
    @user = User.find_by id: params[:user_id]
    unless @user
      flash[:danger] = t "admin.users.user_not_found"
      redirect_to root_path
    end
  end

  private
  def set_locale
    save_session_locale
    I18n.locale = session[:locale] || I18n.default_locale
  end

  def save_session_locale
    if params[:locale]
      session[:locale] = params[:locale]
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit :sign_in, keys: [:name, :email]
    devise_parameter_sanitizer.permit :sign_up, keys: [:name, :email,
      :password, :password_confirmation]
    devise_parameter_sanitizer.permit :account_update,
      keys: [:name,:email, :password, :password_confirmation,
      :current_password, :bio, :company, :position, :skill,
      :phone_number, :facebook, :google, :twitter]
  end
end
