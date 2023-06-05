class CreateQuizzes < ActiveRecord::Migration[7.0]
  def change
    create_table :quizzes do |t|
      t.string :slug, null: false
      t.string :title, null: false
      t.string :description
      t.integer :time_limit_in_seconds
      t.integer :level
      t.boolean :active, default: false
      t.timestamp :featured_at
      t.bigint :created_by

      t.timestamps
    end

    add_foreign_key :quizzes, :users, column: :created_by
  end
end
