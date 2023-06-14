class AddAmountInQuizzes < ActiveRecord::Migration[7.0]
  def change
    add_column :quizzes, :amount, :integer
    add_column :quizzes, :currency_code, :string
  end
end
