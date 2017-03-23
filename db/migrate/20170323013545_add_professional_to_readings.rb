class AddProfessionalToReadings < ActiveRecord::Migration[5.0]
  def change
    add_column :readings, :professional, :boolean, null: false, default: false
  end
end
