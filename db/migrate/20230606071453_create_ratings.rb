class CreateRatings < ActiveRecord::Migration[7.0]
  def change
    create_table :ratings do |t|
      t.references :quiz
      t.references :user
      t.integer :rating

      t.timestamps
    end
  end
end
