class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :find_object, only: :index

  def index
    if params[:last_id]
      @reviews = @object.reviews.created_desc.load_more_desc(params[:last_id])
        .limit Settings.reviews.per_loading
      if @reviews.empty?
        @end_of_data = true
      else
        @end_of_data = @reviews.last.is_end_of_desc_list_data_by_object? @object
      end
    else
      @reviews = @object.reviews.created_desc.limit Settings.reviews.per_loading
    end
    respond_to_js
  end

  def create
    @review = current_user.reviews.build review_params
    if @review.save
      respond_to_js
    else
      flash[:danger] = t "reviews.fail_review"
    end
  end

  def edit
    respond_to_js
  end

  def update
    if @review.update_attributes review_params
      respond_to_js
    else
      flash[:danger] = @review.errors.full_messages
      redirect_to root_path
    end
  end

  def destroy
    if @review.destroy
      respond_to_js
    else
      flash[:danger] = @review.errors.full_messages
      redirect_to root_path
    end
  end

  private
  def review_params
    params.require(:review).permit :content, :reviewable_type, :reviewable_id
  end

  def correct_user
    @review = current_user.reviews.find_by id: params[:id]
    unless @review
      flash[:danger] = t "reviews.review_not_found"
      redirect_to root_path
    end
  end

  def respond_to_js
    respond_to do |format|
      format.js
    end
  end

  def find_object
    class_name = params[:reviewable_type].constantize
    @object = class_name.find_by id: params[:reviewable_id]
    unless @object
      flash[:danger] = t "reviews.fail_load_more"
      redirect_to root_path
    end
  end
end
