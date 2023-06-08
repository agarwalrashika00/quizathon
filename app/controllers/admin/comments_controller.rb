class Admin::CommentsController < Admin::BaseController

  before_action :set_comment, only: [:publish, :unpublish]

  def index
    @q = Comment.ransack(params[:q])
    @q.sorts = 'created_at desc' if @q.sorts.empty?
    @comments = @q.result(distinct: true).page(params[:page])
  end

  def publish
    if @comment.publish
      redirect_to admin_comments_path, notice: 'Comment published successfully'
    else
      redirect_to admin_comments_path, alert: 'Comment cannot be published'
    end
  end

  def unpublish
    if @comment.unpublish
      redirect_to admin_comments_path, alert: 'Comment unpublished successfully'
    else
      redirect_to admin_comments_path, alert: 'Comment cannot be unpublished'
    end
  end

  private

  def set_comment
    unless @comment = Comment.find_by_id(params[:id])
      redirect_to admin_comments_path, alert: 'Comment could not be found'
    end
  end

end
