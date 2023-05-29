class CreateJoinTableGenresQuizzes < ActiveRecord::Migration[7.0]
  def change
    create_join_table :genres, :quizzes do |t|
      t.index [:genre_id, :quiz_id]
      t.index [:quiz_id, :genre_id]
    end
  end
end
