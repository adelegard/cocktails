class UsersController < ApplicationController

  def profile
    @user = User.find(params[:id])
    @lc_ingredients = LiquorCabinet.getByUserId(@user.id)
    @photos = RecipePhoto.where(:user_id => @user.id)

    @rated_recipes = RecipeUser.getRatedRecipesByUserId(params, @user.id)
    @total_ratings_rated = RecipeUser.getTotalRatings(@rated_recipes)
    @full_recipes_rated = Recipe.getFullRecipes(@rated_recipes, @user.id)

    @favorite_recipes = RecipeUser.getFavoriteRecipesByUserId(params, @user.id)
    @total_ratings_favorites = RecipeUser.getTotalRatings(@favorite_recipes)
    @full_recipes_favorites = Recipe.getFullRecipes(@favorite_recipes, @user.id)

    @created_recipes = RecipeUser.getCreatedRecipesByUserId(params, @user.id)
    @total_ratings_created = RecipeUser.getTotalRatings(@created_recipes)
    @full_recipes_created = Recipe.getFullRecipes(@created_recipes, @user.id)

    @num_liked = RecipeUser.getNumLikedCreatedRecipesByUserId(@user.id)
    @num_favorited = RecipeUser.getNumFavoritedCreatedRecipesByUserId(@user.id)

    @follower_users = UserFollow.getFollowers(@user.id)
    @following_users = UserFollow.getFollowing(@user.id)

    @show_follow_btn = (user_signed_in? && current_user.id != @user.id) || !user_signed_in?
    if !@show_follow_btn
        @is_following = false
        if user_signed_in?
            @is_following = UserFollow.where(:user_id => current_user.id, :follow_user_id => @user.id).length == 1
        end
    end

    render 'users/profile'
  end

end
