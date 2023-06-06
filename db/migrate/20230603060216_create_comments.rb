class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.references :user
      t.boolean :published
      t.references :parent_comment
      t.references :commentable, polymorphic: true

      t.timestamps
    end
  end
end
