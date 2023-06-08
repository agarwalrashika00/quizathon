class ChangePublishedDefaultInComments < ActiveRecord::Migration[7.0]
  def change
    change_table :comments do |t|
      t.change :published, :boolean, default: true
    end
  end
end
