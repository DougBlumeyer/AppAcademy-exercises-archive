class Post < ActiveRecord::Base
  validates :title, :author_id, presence: true
  #validates :subs, length: { minimum: 1 }

  belongs_to :author, class_name: 'User'
  has_many :subs, through: :post_subs, source: :sub
  has_many :post_subs
  has_many :comments
  has_many :votes, as: :votable

  def comments_by_parent_id
    @comments_by_parent_id = Hash.new { |h,k| h[k] = [] }

    comments.each do |comment|
      @comments_by_parent_id[comment.parent_comment_id] << comment
    end

    @comments_by_parent_id
  end

  def score
    votes.map(&:value).inject(:+) || 0 
  end
end
