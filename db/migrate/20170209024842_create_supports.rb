class CreateSupports < ActiveRecord::Migration[5.0]
  def change
    create_table :supports do |t|
      t.references :user, foreign_key: true
      t.text :content
      t.boolean :from_admin, default: false

      t.timestamps
    end
  end
end
