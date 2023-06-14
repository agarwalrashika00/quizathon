class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.references :user
      t.string :data
      t.boolean :read, default: 0

      t.timestamps
    end
  end
end
