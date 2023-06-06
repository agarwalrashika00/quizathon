class Comment < ApplicationRecord

  belongs_to :commentable, polymorphic: true
  belongs_to :parent_comment, class_name: 'Comment', optional: true
  has_many :child_comments, class_name: 'Comment', foreign_key: 'parent_comment_id', dependent: :destroy
  has_rich_text :data
  belongs_to :user

end
