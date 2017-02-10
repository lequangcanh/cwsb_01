class CreateReports < ActiveRecord::Migration[5.0]
  def change
    create_table :reports do |t|
      t.references :user, foreign_key: true
      t.references :venue, foreign_key: true
      t.integer :type_report
      t.text :content

      t.timestamps
    end
  end
end
