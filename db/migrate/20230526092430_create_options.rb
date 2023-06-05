class CreateOptions < ActiveRecord::Migration[7.0]
  def change
    create_table :question_options do |t|
      t.references :question, foreign_key: true
      t.string :type
      t.string :data
      t.boolean :correct, dafault: false
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
