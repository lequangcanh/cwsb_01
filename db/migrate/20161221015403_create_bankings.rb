class CreateBankings < ActiveRecord::Migration[5.0]
  def change
    create_table :bankings do |t|
      t.string :card_name
      t.string :card_number
      t.string :card_address
      t.string :banking_name
      t.boolean :verified, default: false
      t.integer :pending_time
      t.references :payment_method

      t.timestamps
    end
  end
end
