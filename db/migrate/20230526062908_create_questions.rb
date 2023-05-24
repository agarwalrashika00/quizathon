class CreateQuestions < ActiveRecord::Migration[7.0]
  def change
    create_table :questions do |t|
      t.string :slug, null: false
      t.string :title, null: false
      t.string :description
      t.boolean :active, default: true
      t.integer :score

      t.timestamps
    end
  end
end
