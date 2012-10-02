class NotificationsMailer < ActionMailer::Base
  default :from => "contact@cocktailrecipes.com"
  default :to => "emailtester147@gmail.com"

  def new_message(message)
    @message = message
    mail(:subject => "[CocktailRecipes.com] #{message.subject}")
  end
end
