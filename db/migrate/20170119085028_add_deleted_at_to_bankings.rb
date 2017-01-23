class AddDeletedAtToBankings < ActiveRecord::Migration[5.0]
  def change
    add_column :bankings, :deleted_at, :datetime
    add_index :bankings, :deleted_at
  end
end
