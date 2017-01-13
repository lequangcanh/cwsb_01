class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.integer :status, default: 1
      t.float :total_paid
      t.references :venue
      t.references :payment_detail, polymorphic: true
      t.datetime "deleted_at"

      t.timestamps
    end
    add_index :orders, :deleted_at
  end
end
