class Post < ActiveRecord::Base
  validates :title, :author_id, presence: true
  #validates :subs, length: { minimum: 1 }

  belongs_to :author, class_name: 'User'
  has_many :subs, through: :post_subs, source: :sub
  has_many :post_subs
  has_many :comments
end
