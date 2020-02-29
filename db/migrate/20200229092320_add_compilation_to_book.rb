class AddCompilationToBook < ActiveRecord::Migration[5.0]
  def change
    add_column :books, :compilation, :boolean, default: false
    add_column :readings, :compilation, :boolean, default: false
  end
end
