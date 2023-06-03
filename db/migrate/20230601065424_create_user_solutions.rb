class CreateUserSolutions < ActiveRecord::Migration[7.0]
  def change
    create_table :user_solutions do |t|
      t.references :quiz_question
      t.references :user
      t.references :marked_option

      t.timestamps
    end
  end
end
