class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  require 'two_factor'
  has_many :vehicles

  
  
  has_many :publishes
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

        validates :email, presence: true, uniqueness: true
        #validates :password, format: { with: /\A(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)[\w\W]{8,}\z/ }, length: { minimum: 8 }
        validates :encrypted_password, presence: true

        #custom validation on password 
        validate :password_complexity
        #custom validation on image
        validate :image_format
        #for chatting
        has_many :chats




        

        validates :first_name, presence: true, format: { with: /\A[a-zA-Z]+\z/, message: "only allows letters" }
        validates :last_name, presence: true, format: { with: /\A[a-zA-Z]+\z/, message: "only allows letters" }
        validates :phone_number,length: { is: 10 }, numericality: { only_integer: true },allow_blank: true


        validates :dob, presence: true
        validates :title, presence: true
        has_one_attached :image
        before_create :create_activation_digest

        
     # foe sending otp and verification

        def send_passcode
          response = TwoFactor.send_passcode(phone_number)
          if response && response['Status'].to_s.downcase == 'success'
            update_column(:session_key, response['Details'])
            true
          else
            false
          end
        end
        
      
        def verify_passcode(passcode)
          TwoFactor.verify_passcode(session_key, passcode)['Status'].to_s.downcase == 'success'
        end




     #password validation 

        def password_complexity
          if password.present? && !password.match(/\A(?=.*[a-z])(?=.*[A-Z])(?=.*\W)/)
            errors.add(:password, "must include at least one lowercase letter, one uppercase letter, and one special character")
          end
        end




      
  # for email verification 
        def send_activation_email
          UserMailer.account_activation(self).deliver_now
        end
        
        def activate
          update_columns(activated: true, activated_at: Time.zone.now)
        end
      
        attr_accessor :activation_token
      
        def authenticated?(attribute, token)
          digest = send("#{attribute}_digest")
          return false if digest.nil?
          BCrypt::Password.new(digest).is_password?(token)
        end
      
        # private
      
        def create_activation_digest
          self.activation_token = SecureRandom.urlsafe_base64
          self.activate_token = self.activation_token
          self.activation_digest = User.digest(self.activation_token)
        end
      
        def self.digest(token)
          cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
          BCrypt::Password.create(token, cost: cost)
        end



        # for image validation
        def image_format
          return unless image.attached?
      
          unless image.content_type.in?(%w[image/jpeg image/png])
            errors.add(:image)
          end
        end
end