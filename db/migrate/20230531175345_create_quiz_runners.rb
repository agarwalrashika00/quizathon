class CreateQuizRunners < ActiveRecord::Migration[7.0]
  def change
    create_table :quiz_runners do |t|
      t.references :user
      t.references :quiz
      t.integer :status
      t.integer :score
      t.text :questions_sorting_order, array: true, default: []
      t.integer :current_question_number

      t.timestamps
    end
  end
end
