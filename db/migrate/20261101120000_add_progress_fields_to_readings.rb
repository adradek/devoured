class AddProgressFieldsToReadings < ActiveRecord::Migration[8.1]
  def change
    change_table :readings, bulk: true do |t|
      t.integer :total_pages
      t.integer :attempt, null: false, default: 1
    end
  end
end
