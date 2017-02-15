class AddIsReadToSupport < ActiveRecord::Migration[5.0]
  def change
    add_column :supports, :is_read, :boolean, default: false
  end
end
