class CreateQuizOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :quiz_orders do |t|
      t.string :session_id
      t.references :quiz
      t.references :user
      t.string :status

      t.timestamps
    end
  end
end
