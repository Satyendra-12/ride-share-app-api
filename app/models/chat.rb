class Chat < ApplicationRecord
    belongs_to :user
    belongs_to :passenger
  
    validates :content, presence: true

end
