class Comment < ApplicationRecord
  include HasSafeMedia

  belongs_to :post

  validates :body, presence: true, length: { minimum: 2, maximum: 2_000 }

  def self.comments_for_post(post_id)
    Comment.where("post_id = ? and parent_id = 0", post_id).order("id")
  end

  def self.replies_for_post(post_id)
    Comment.where("post_id = ? and parent_id != 0", post_id).order(["parent_id", "id"]).group_by { |comment| comment["parent_id"] }
  end
end
