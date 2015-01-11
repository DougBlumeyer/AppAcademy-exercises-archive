class User < ActiveRecord::Base
  validates :username, presence: true, uniqueness: true

  has_many(
    :contacts,
    class_name: 'Contact',
    foreign_key: :user_id,
    primary_key: :id,
    dependent: :destroy
  )

  has_many(
    :contact_shares_received,
    class_name: 'ContactShare',
    foreign_key: :user_id,
    primary_key: :id
  )

  has_many(
    :contacts_shared_with,
    through: :contact_shares_received,
    source: :contact
  )

  #has_many :contact_shares_sent

  #has_many :contacts_shared

  has_many :comments, :as => :commentable  
end
