class CreateIntents < ActiveRecord::Migration[5.0]
  def change
    create_table :intents do |t|
      t.references :user,     foreign_key: true
      t.references :intended, polymorphic: true, index: true

      t.timestamps
    end
  end
end
