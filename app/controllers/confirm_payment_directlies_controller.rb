class ConfirmPaymentDirectliesController < ApplicationController
  before_action :load_user_payment_directly, only: :update

  def show
    @venues = current_user.venues
  end

  def update
    respond_to do |format|
      if params[:status].present?
        if @user_payment_directly.update status: params[:status]
          PaymentMailer.change_status_payment_directly(@user_payment_directly.status,
            @user_payment_directly.email).deliver_later
        else
          flash[:danger] = t "flash.danger_message"
          redirect_to confirm_payment_directlies_path
        end
      end
      format.json do
        render json: {
          status: @user_payment_directly.status,
          flash: I18n.t("flash.success_message")
        }
      end
    end
  end

  private

  def load_user_payment_directly
    @user_payment_directly = UserPaymentDirectly.find_by id: params[:user_payment_directly_id]
    unless @user_payment_directly
      flash[:danger] = t "flash.danger_message"
    end
  end
end
