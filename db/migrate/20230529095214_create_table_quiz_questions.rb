class CreateTableQuizQuestions < ActiveRecord::Migration[7.0]
  def change
    create_table :quiz_questions do |t|
      t.references :quiz, foreign_key: true
      t.references :question, foreign_key: true
      t.boolean :active, default: true
      t.index [:question_id, :quiz_id]
      t.index [:quiz_id, :question_id]
    end
  end
end
