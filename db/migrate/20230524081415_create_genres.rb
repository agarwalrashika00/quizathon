class CreateGenres < ActiveRecord::Migration[7.0]
  def change
    create_table :genres do |t|
      t.string :slug, null: false
      t.string :title
      t.string :description
      t.references :super_genre, foreign_key: { to_table: :genres }
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
