class RemoveRateFromReview < ActiveRecord::Migration[5.0]
  def change
    remove_column :reviews, :rate, :integer
  end
end
