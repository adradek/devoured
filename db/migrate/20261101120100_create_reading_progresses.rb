class CreateReadingProgresses < ActiveRecord::Migration[8.1]
  def change
    create_table :reading_progresses do |t|
      # readings.id is a serial (integer), not bigint
      t.references :reading, type: :integer, null: false, foreign_key: true, index: false
      t.date :date, null: false
      t.integer :from_page, null: false
      t.integer :to_page, null: false
      t.integer :attempt, null: false
      t.text :note

      t.timestamps

      t.index %i[reading_id attempt date]
    end
  end
end
