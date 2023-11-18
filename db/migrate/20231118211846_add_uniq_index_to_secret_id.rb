class AddUniqIndexToSecretId < ActiveRecord::Migration[6.0]
  def change
    add_index :users, :secret_id, unique: true
  end
end
