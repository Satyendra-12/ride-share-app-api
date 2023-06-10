class Publish < ApplicationRecord
  
  has_one :user
  has_many :passengers

  reverse_geocoded_by :source_latitude, :source_longitude, address: :source
  reverse_geocoded_by :destination_latitude, :destination_longitude, address: :destination

end