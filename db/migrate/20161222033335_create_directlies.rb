class CreateDirectlies < ActiveRecord::Migration[5.0]
  def change
    create_table :directlies do |t|
      t.text :name
      t.text :address
      t.text :phone_number
      t.boolean :verified
      t.integer :pending_time
      t.text :message
      t.references :payment_method, foreign_key: true

      t.timestamps
    end
  end
end
