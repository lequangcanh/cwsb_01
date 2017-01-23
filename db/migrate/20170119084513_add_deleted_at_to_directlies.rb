class AddDeletedAtToDirectlies < ActiveRecord::Migration[5.0]
  def change
    add_column :directlies, :deleted_at, :datetime
    add_index :directlies, :deleted_at
  end
end
