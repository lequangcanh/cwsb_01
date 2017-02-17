class ChangeToUser < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :bio, :text
    rename_column :users, :position, :address
  end
end
