class RemoveCompilationColumnFromReading < ActiveRecord::Migration[6.0]
  def change
    remove_column :readings, :compilation, :boolean, default: false
  end
end
