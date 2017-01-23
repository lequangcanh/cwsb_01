class Search::ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_space, only: :index
  before_action :correct_user, only: [:edit, :update, :destroy]

  def index
    if params[:last_id]
      @reviews = @space.reviews.created_desc.load_more_desc(params[:last_id])
        .limit Settings.reviews.per_loading
      @end_of_data = @reviews.last.is_end_of_desc_list_data?
    else
      @reviews = @space.reviews.created_desc.limit Settings.reviews.per_loading
    end
    respond_to_js
  end

  def create
    @review = current_user.reviews.build review_params
    if @review.save
      respond_to_js
    else
      flash[:danger] = t "search.spaces.show.fail_review"
    end
  end

  def edit
    @space = @review.space
    respond_to_js
  end

  def update
    if @review.update_attributes review_params
      respond_to_js
    else
      flash[:danger] = @review.errors.full_messages
      redirect_to search_spaces_path
    end
  end

  def destroy
    if @review.destroy
      respond_to_js
    else
      flash[:danger] = @review.errors.full_messages
      redirect_to search_spaces_path
    end
  end

  private
  def review_params
    params.require(:review).permit :user_id, :space_id, :content
  end

  def find_space
    @space = Space.find_by id: params[:space_id]
    unless @space
      flash[:danger] = t "search.spaces.space_not_found" 
      redirect_to search_spaces_path
    end
  end

  def correct_user
    @review = current_user.reviews.find_by id: params[:id]
    unless @review
      flash[:danger] = t "search.reviews.review_not_found"
      redirect_to search_spaces_path 
    end
  end

  def respond_to_js
    respond_to do |format|
      format.js
    end
  end

  def get_space_of_review
    @space = @review.space
  end
end
