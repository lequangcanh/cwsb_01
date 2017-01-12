class Admin::ActivitiesController < Admin::BaseController
  
  def index
    @activities = Activity.order_desc.page(params[:page])
      .per Settings.admin.activities.per_page
  end
end
