class CreateUserPaymentDirectlies < ActiveRecord::Migration[5.0]
  def change
    create_table :user_payment_directlies do |t|
      t.string :name
      t.string :email
      t.string :address
      t.string :phone
      t.boolean :verified
      t.integer :status, default: 1
      t.integer :pending_time
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
