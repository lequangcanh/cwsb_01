class CreateUserPaymentBankings < ActiveRecord::Migration[5.0]
  def change
    create_table :user_payment_bankings do |t|
      t.string :card_name
      t.string :card_number
      t.string :card_address
      t.string :banking_name
      t.integer :status, default: 1
      t.integer :pending_time
      t.string :email
      t.boolean :verified, default: false
      t.string :name

      t.timestamps
    end
  end
end
