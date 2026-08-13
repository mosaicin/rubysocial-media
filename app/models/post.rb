class Post < ApplicationRecord
  include HasSafeMedia

  belongs_to :topic

  validates :title, presence: true, length: { maximum: 300 }
  validates :body, presence: true, length: { maximum: 20_000 }

  def replies
    Comment.where("post_id = ? and parent_id == 0", id).order(["parent_id", "id"]).group_by { |comment| comment["parent_id"] }
  end

  def comments
    Comment.where("post_id = ? and parent_id != 0", id).order("id")
  end
end
