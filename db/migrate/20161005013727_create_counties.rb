class CreateCounties < ActiveRecord::Migration[5.0]
  def change
    create_table :counties do |t|
      t.string :name, null: false
      t.references :city, index: true, foreign_key: true
      t.datetime "deleted_at"

      t.timestamps
    end
    add_index :counties, :deleted_at
  end
end
