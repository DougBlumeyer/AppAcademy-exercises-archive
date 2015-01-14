class Goal < ActiveRecord::Base
  validates :title, :description, :user_id, presence: true
  validates :title, uniqueness: { scope: :user_id}

  belongs_to :user

  include Commentable
end
