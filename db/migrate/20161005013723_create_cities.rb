class CreateCities < ActiveRecord::Migration[5.0]
  def change
    create_table :cities do |t|
      t.string :name, null: false
      t.string :postal_code, null: false
      t.references :country, index: true, foreign_key: true
      t.datetime "deleted_at"

      t.timestamps
    end
    add_index :cities, :deleted_at
  end
end
