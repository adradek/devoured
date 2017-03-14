class CreateBooks < ActiveRecord::Migration[5.0]
  def change
    create_table :books do |t|
      t.string :title,  null: false
      t.string :author
      t.boolean :short, null: false, default: false

      t.timestamps
    end

    add_index :books, [:title, :author], unique: true
  end
end
