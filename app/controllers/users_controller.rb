class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @lc_ingredients = LiquorCabinet.getByUserId(@user.id)
    @photos = RecipePhoto.where(:user_id => @user.id)

    @rated_recipes = RecipeUser.getRatedRecipesByUserId(params, @user.id)
    @total_ratings_rated = Recipe.total_ratings(@rated_recipes)
    @full_recipes_rated = Recipe.getFullRecipes(@rated_recipes, @user.id)

    @favorite_recipes = RecipeUser.getFavoriteRecipesByUserId(params, @user.id)
    @total_ratings_favorites = Recipe.total_ratings(@favorite_recipes)
    @full_recipes_favorites = Recipe.getFullRecipes(@favorite_recipes, @user.id)

    @created_recipes = RecipeUser.getCreatedRecipesByUserId(params, @user.id)
    @total_ratings_created = Recipe.total_ratings(@created_recipes)
    @full_recipes_created = Recipe.getFullRecipes(@created_recipes, @user.id)

    @num_liked = RecipeUser.getNumLikedCreatedRecipesByUserId(@user.id)
    @num_favorited = RecipeUser.getNumFavoritedCreatedRecipesByUserId(@user.id)

    @follower_users = UserFollow.getFollowers(@user.id)
    @following_users = UserFollow.getFollowing(@user.id)

    @is_current_user = false
    @is_following = false
    if user_signed_in?
        @is_current_user = @user.id == current_user.id
        @is_following = UserFollow.where(:user_id => current_user.id, :follow_user_id => @user.id).length == 1
    end

    # friendly_id magic that redirects users with an old url to the current one
    if request.path != user_path(@user)
        redirect_to @user, :status => :moved_permanently
    else
        render 'users/profile'
    end
  end

end
