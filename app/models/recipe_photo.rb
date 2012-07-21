class RecipePhoto < ActiveRecord::Base
  belongs_to :recipe
  belongs_to :user

#   has_attached_file :photo,
#       :storage => :s3,
#       :styles => { :small => "150x150>" },
#       :bucket => 'adelegard_cocktails',
#       :path => "/recipes/:recipe_id/images/:user_id/:style.:extension",
#       :s3_credentials => "#{Rails.root}/config/s3.yml"

    Paperclip.interpolates :recipe_id do |attachment, style|
      attachment.instance.recipe_id
    end
    Paperclip.interpolates :id do |attachment, style|
      attachment.instance.id
    end
    Paperclip.interpolates :photo_file_name do |attachment, style|
      attachment.instance.photo_file_name
    end

    has_attached_file :photo, :styles => {:icon => '25x25', :tiny => '50x50', :thumb => '100x100', :medium => '300x300>', :large => '600x600>'},
                              :url  => "/photos/recipes/:recipe_id/recipe_photos/:id/:basename_:style.:extension",
                              :path => ":rails_root/public/photos/recipes/:recipe_id/recipe_photos/:id/:basename_:style.:extension"

    validates_attachment_size :photo, :less_than => 5.megabytes
    validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']
end
