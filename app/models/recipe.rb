require 'rubygems'
require 'aws/s3'

class Recipe < ActiveRecord::Base
	include AWS::S3
	
	has_many :recipe_ingredients
	has_many :recipe_users
	has_many :ingredients, :through => :recipe_ingredients
	has_many :users, :through => :recipe_users

	self.per_page = 12

	has_attached_file :photo,
		:storage => :s3,
		:styles => { :thumbnail => "100x100>", :small => "150x150>" , :medium => "300x300"},
		:bucket => 'adelegard_cocktails',
		:path => "/recipes/:recipe_id/images/:user_id/:id/:style.:extension",
		:s3_credentials => {
			:access_key_id => ENV['AKIAJNDWPCPJTY4UA7XA'],
			:secret_access_key => ENV['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']
		}

	validates_attachment_size :photo, :less_than => 5.megabytes
	validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']
end
