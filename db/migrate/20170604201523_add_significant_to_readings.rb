class AddSignificantToReadings < ActiveRecord::Migration[5.0]
  def change
    add_column :readings, :significant, :boolean, default: false
  end
end
