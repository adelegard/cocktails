class RecipeUser < ActiveRecord::Base
	belongs_to :recipe
	belongs_to :user

	has_attached_file :photo,
		:storage => :s3,
		:styles => { :small => "150x150>" },
		:bucket => 'adelegard_cocktails',
		:path => "/recipes/:recipe_id/images/:user_id/:style.:extension",
		:s3_credentials => "#{Rails.root}/config/s3.yml"

	validates_attachment_size :photo, :less_than => 5.megabytes
	validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']
end
