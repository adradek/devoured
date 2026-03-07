class AddProfessionalToWatching < ActiveRecord::Migration[8.1]
  def change
    add_column :watchings, :professional, :boolean, null: false, default: false
  end
end
