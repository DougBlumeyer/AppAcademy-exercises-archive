class Contact < ActiveRecord::Base
  validates :user_id, :name, :email, presence: true
  validates :email, :uniqueness => { :scope => :user_id }
  validates :favorite, inclusion: { in: [0, 1] }

  belongs_to(
    :owner,
    class_name: 'User',
    foreign_key: :user_id,
    primary_key: :id
  )

  has_many :contact_shares, dependent: :destroy

  has_many :users_shared_with, through: :contact_shares, source: :user

  has_many :comments, :as => :commentable
end
