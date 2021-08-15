class AddExtraTomatoesFieldsToFilm < ActiveRecord::Migration[5.0]
  def change
    add_column :films, :tomatoes_top, :integer
    add_column :films, :tomatoes_all, :integer
  end
end
