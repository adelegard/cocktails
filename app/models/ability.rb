class Ability
  include CanCan::Ability

  def initialize(user)
       user ||= User.new # guest user (not logged in)
       if user.role? :super_admin
         can :manage, :all
       else if user.role? :basic
         
         can :read, [Ingredient, LiquorCabinet, Recipe, User]
         
         #can manage my own cabinet
         can :manage, LiqourCabinet do |cabinet|
          cabinet.try(:user) == user
         end
         
         #can manage my own recipes
         can :manage, Recipe do |recipe|
          recipe.try(:recipe_users).include?(user)
         end

         #can edit my own ingredients? probably not
         #can [:create, :update], Ingredient do |ingredient|
         # ingredient.try(:created_by)== user
         #end
         
         #can manage my own profile
         can :manage, User do |testUser|
          testUser == user
         end
         
       end
  end
end
