class CreatePayments < ActiveRecord::Migration[7.0]
  def change
    create_table :payments do |t|
      t.string :session_id
      t.references :quiz
      t.references :user
      t.string :status
      t.integer :amount
      t.string :currency_code

      t.timestamps
    end
  end
end
