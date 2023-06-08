class Comment < ApplicationRecord

  belongs_to :commentable, polymorphic: true
  belongs_to :parent_comment, class_name: 'Comment', optional: true
  has_many :child_comments, class_name: 'Comment', foreign_key: 'parent_comment_id', dependent: :destroy
  has_rich_text :data
  belongs_to :user

  validate :single_level_nesting

  scope :published, -> {
    where(published: true)
  }

  def publish
    update_column(:published, true)
  end

  def unpublish
    update_column(:published, false)
  end

  def self.ransackable_attributes(auth_object = nil)
    ['commentable_id', 'commentable_type', 'created_at', 'parent_comment_id', 'published', 'updated_at', 'user_id']
  end

  def self.ransackable_associations(auth_object = nil)
    %w[rich_text_data user parent_comment]
  end

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
