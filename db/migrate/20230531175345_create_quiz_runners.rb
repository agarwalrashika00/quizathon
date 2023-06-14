class CreateQuizRunners < ActiveRecord::Migration[7.0]
  def change
    create_table :quiz_runners do |t|
      t.references :user
      t.references :quiz
      t.integer :status
      t.integer :score
      t.string :questions_sorting_order
      t.integer :current_question_number

      t.timestamps
    end
  end
end
