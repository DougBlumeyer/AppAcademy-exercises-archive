class Comment < ActiveRecord::Base
  validates :post_id, :author_id, presence: true
  belongs_to :post
  belongs_to :author, class_name: "User"
  has_many :child_comments, class_name: "Comment", foreign_key: :parent_comment_id
end
