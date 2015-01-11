class ContactShare < ActiveRecord::Base
  validates :contact_id, :user_id, presence: true
  validates :contact_id, :uniqueness => { :scope => :user_id }

  belongs_to :contact
  belongs_to :user

  has_one :sharer, through: :contact, source: :owner

  has_many :comments, :as => :commentable  
end
