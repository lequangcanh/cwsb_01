class CreateReviews < ActiveRecord::Migration[5.0]
  def change
    create_table :reviews do |t|
      t.string :content, null: false
      t.integer :rate
      t.references :user, index: true, foreign_key: true
      t.datetime "deleted_at"

      t.timestamps
    end
    add_index :reviews, :deleted_at
  end
end
