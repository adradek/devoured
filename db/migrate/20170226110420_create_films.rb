class CreateFilms < ActiveRecord::Migration[5.0]
  def change
    create_table :films do |t|
      t.string  :name_rus
      t.string  :name_eng
      t.boolean :seria,   null: false, default: false
      t.integer :imdb
      t.string  :tomatoes

      t.timestamps
    end
  end
end
