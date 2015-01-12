class Comment < ActiveRecord::Base
  validates :post_id, :author_id, presence: true
  belongs_to :post
  belongs_to :author, class_name: "User"
end
