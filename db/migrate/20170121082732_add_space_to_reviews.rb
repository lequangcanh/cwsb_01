class AddSpaceToReviews < ActiveRecord::Migration[5.0]
  def change
    add_reference :reviews, :space, foreign_key: true
  end
end
