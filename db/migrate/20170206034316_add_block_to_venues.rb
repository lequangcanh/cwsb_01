class AddBlockToVenues < ActiveRecord::Migration[5.0]
  def change
    add_column :venues, :block, :boolean, default: false
  end
end
