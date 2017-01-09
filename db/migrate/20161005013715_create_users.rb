class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :password
      t.string :phone_number
      t.boolean :verified
      t.integer :status, default: 1
      t.integer :role
      t.string :bio
      t.string :company
      t.string :position
      t.string :skill
      t.string :facebook
      t.string :google
      t.string :twitter

      t.timestamps
    end
  end
end
