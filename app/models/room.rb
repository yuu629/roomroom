class Room < ApplicationRecord

  belongs_to :user

  has_many :reservations
  has_many :guest_reviews
  has_many :reviews

  has_many_attached :photos
  has_rich_text :description

  geocoded_by :address
  after_validation :geocode, if: :address_changed?
  
  validates :home_type, presence: true
  validates :room_type, presence: true
  validates :accommodate, presence: true
  validates :bed_room, presence: true
  validates :bath_room, presence: true
  
  def average_rating
    guest_reviews.count == 0 ? 0 : guest_reviews.average(:stars).round(2).to_i
  end  

end
