class Album < ActiveRecord::Base
  RECORDING_TYPES = %w(live studio) 

  validates :name, :recording_type, :band_id, presence: true
  validates :recording_type, inclusion: RECORDING_TYPES

  has_many :tracks, dependent: :destroy
  belongs_to :band
end
