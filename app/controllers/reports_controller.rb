class ReportsController < ApplicationController

  def create
    report = current_user.reports.build report_params
    if report.save
      flash[:success] = t "flash.report_success"
    else
      flash[:danger] = t "flash.danger_message"
    end
    redirect_to :back 
  end
  
  private
  def report_params
    params.require(:report).permit :content, :venue_id
  end
end
