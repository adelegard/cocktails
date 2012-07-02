class User < ActiveRecord::Base
  has_many :recipe_users
  has_many :recipe, :through => :recipe_users
  has_many :recipe_photos
  has_many :authentications
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :nickname, :name, :password, :password_confirmation, :remember_me

  class << self

    def find_for_facebook_oauth(access_token, signed_in_resource=nil)
      data = access_token.extra.raw_info
      if user = self.find_by_email(data.email)
        if user.nickname == nil || user.name == nil
          user.nickname = data["first_name"] if data["first_name"]
          user.name = data["name"] if data["name"]
          user.save
        end
        user
      else
        user = User.new(:email => data.email, :password => Devise.friendly_token[0,20])
        user.nickname = data["first_name"] if data["first_name"]
        user.name = data["name"] if data["name"]
        user.save
      end
    end

  	def find_for_open_id(access_token, signed_in_resource=nil)
  	  data = access_token.info
  	  if user = User.where(:email => data["email"]).first
        if user.nickname == nil || user.name == nil
          user.nickname = data["first_name"] if data["first_name"]
          user.name = data["name"] if data["name"]
          user.save
        end
        user
  	  else
        user = User.new(:email => data["email"], :password => Devise.friendly_token[0,20])
        user.nickname = data["first_name"] if data["first_name"]
        user.name = data["name"] if data["name"]
        user.save
  	  end
  	end

    def find_for_twitter_oauth(omniauth)
      authentication = Authentication.find_by_provider_and_uuid(omniauth['provider'], omniauth['uid'])
      if authentication && authentication.user
        authentication.user
      else
        User.new(:nickname => omniauth['nickname'], :name => omniauth['name'])
      end
    end

    def new_with_session(params, session)
      super.tap do |user|
        if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
          user.email = data["email"]
        end
      end
    end
  end

end
