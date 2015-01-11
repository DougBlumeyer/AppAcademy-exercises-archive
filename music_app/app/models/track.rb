class Track < ActiveRecord::Base
  CATEGORIES = %w(bonus regular)

  validates :name, :album_id, :category, presence: true
  validates :category, inclusion: CATEGORIES

  belongs_to :album
  has_one :band, through: :album, source: :band
  has_many :notes
end
