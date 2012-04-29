class ApplicationController < ActionController::Base
  # For some reason I can't call the recipe_uesrs#rate method without this forgery line below being commented out.
  # When it is uncommented devise logs us out, too
  #protect_from_forgery
end
