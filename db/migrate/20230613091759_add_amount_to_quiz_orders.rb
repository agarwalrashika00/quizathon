class AddAmountToQuizOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :quiz_orders, :amount, :integer
    add_column :quiz_orders, :currency_code, :string
  end
end
