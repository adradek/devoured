class AddSecretIdToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :secret_id, :string

    User.all.each { |u| u.valid?; u.save! }
  end
end
