class Comment < ApplicationRecord

  belongs_to :commentable, polymorphic: true
  belongs_to :parent_comment, class_name: 'Comment', optional: true
  has_many :child_comments, class_name: 'Comment', foreign_key: 'parent_comment_id', dependent: :destroy
  has_rich_text :data
  belongs_to :user

  validate :single_level_nesting

  private

  def any_child_comment_has_child_comments?
    Comment.exists?(parent_comment_id: child_comment_ids)
  end

  def single_level_nesting
    if parent_comment&.parent_comment_id? || any_child_comment_has_child_comments? || (parent_comment.present? && child_comments.present?)
      errors.add :base, :nesting_level_too_deep, message: 'only one level of nesting is allowed'
    end
  end

end
