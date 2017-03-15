class CreateWatchings < ActiveRecord::Migration[5.0]
  def change
    create_table :watchings do |t|
      t.references :user, foreign_key: true
      t.references :film, foreign_key: true
      t.date :start
      t.date :finish
      t.string :rate

      t.timestamps
    end
  end
end
