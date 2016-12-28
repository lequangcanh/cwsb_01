class CreateAddresses < ActiveRecord::Migration[5.0]
  def change
    create_table :addresses do |t|
      t.string :details, null: false
      t.string :city
      t.float :latitude
      t.float :longitude
      t.string :postal_code
      t.string :street_address
      t.string :unit
      t.references :county, index: true ,foreign_key: true
      t.belongs_to :venue, index: true
      t.datetime "deleted_at"

      t.timestamps
    end
    add_index :addresses, :deleted_at
  end
end
