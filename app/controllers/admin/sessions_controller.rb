class Admin::SessionsController < Devise::SessionsController
  layout "admin/application"

  def new
    super
  end

  def create
    def after_sign_in_path_for resource
      admin_root_path
    end
    super
  end

  def destroy
    def after_sign_out_path_for resource
      new_admin_session_path
    end
    super
  end
end
