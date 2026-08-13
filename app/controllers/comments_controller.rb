class CommentsController < ApplicationController
  def create
    @comment = Comment.new(comment_params)
    @comment.parent_id = 0 unless params[:parent_id].present?
    @comment.save
    render json: { comment: @comment, errors: @comment.errors }
  end

  private

  def comment_params
    params.permit(:body, :post_id, :parent_id, media: [])
  end
end
