Paperclip.interpolates :user_id do |attachment, style|
  attachment.instance.recipe_user.user_id.parameterize
end