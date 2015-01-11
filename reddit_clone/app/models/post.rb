class Post < ActiveRecord::Base
  validates :title, :sub_id, :author_id, presence: true

  belongs_to :author, class_name: 'User'
  belongs_to :sub
end
