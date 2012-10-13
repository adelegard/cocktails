class UsersController < ApplicationController

  # GET /users/:id
  def show
    @user = User.find(params[:id])
    @lc_ingredients = LiquorCabinet.getByUserId(@user.id)
    @photos = RecipePhoto.where(:user_id => @user.id)

    liked_recipes = RecipeUser.getLikedRecipesByUserId(params, @user.id)
    @full_recipes_liked = Recipe.getFullRecipes(liked_recipes, @user.id)

    disliked_recipes = RecipeUser.getDislikedRecipesByUserId(params, @user.id)
    @full_recipes_disliked = Recipe.getFullRecipes(disliked_recipes, @user.id)

    favorite_recipes = RecipeUser.getFavoriteRecipesByUserId(params, @user.id)
    @full_recipes_favorites = Recipe.getFullRecipes(favorite_recipes, @user.id)

    created_recipes = RecipeUser.getCreatedRecipesByUserId(params, @user.id)
    @full_recipes_created = Recipe.getFullRecipes(created_recipes, @user.id)

    @num_liked = RecipeUser.getNumLikedCreatedRecipesByUserId(@user.id)
    @num_disliked = RecipeUser.getNumDislikedCreatedRecipesByUserId(@user.id)
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
        render :profile
    end
  end

end
