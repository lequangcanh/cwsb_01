class ConfirmPaymentBankingsController < ApplicationController
  before_action :load_user_payment_banking, only: :update

  def show
    @venues = current_user.venues
  end

  def update
    respond_to do |format|
      if params[:status].present?
        if @user_payment_banking.update status: params[:status]
          PaymentMailer.change_status_payment_banking(@user_payment_banking.status,
            @user_payment_banking.email).deliver_later
        else
          flash[:danger] = t "flash.danger_message"
          redirect_to confirm_payment_directlies_path
        end
      end
      format.json do
        render json: {
          status: @user_payment_banking.status,
          flash: I18n.t("flash.success_message")
        }
      end
    end
  end

  private

  def load_user_payment_banking
    @user_payment_banking = UserPaymentBanking.find_by id: params[:user_payment_banking_id]
    unless @user_payment_banking
      flash[:danger] = t "flash.danger_message"
      redirect_to confirm_payment_directlies_path
    end
  end
end
