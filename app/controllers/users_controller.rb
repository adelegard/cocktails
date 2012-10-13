class UsersController < ApplicationController

  # GET /users/:id
  def show
    @user = User.find(params[:id])
    @lc_ingredients = LiquorCabinet.by_user_id(@user.id)
    @photos = RecipePhoto.where(:user_id => @user.id)

    liked_recipes = RecipeUser.liked_recipes_by_user_id(params, @user.id)
    @full_recipes_liked = Recipe.full_recipes(liked_recipes, @user.id)

    disliked_recipes = RecipeUser.disliked_recipes_by_user_id(params, @user.id)
    @full_recipes_disliked = Recipe.full_recipes(disliked_recipes, @user.id)

    favorite_recipes = RecipeUser.favorite_recipes_by_user_id(params, @user.id)
    @full_recipes_favorites = Recipe.full_recipes(favorite_recipes, @user.id)

    created_recipes = RecipeUser.created_recipes_by_user_id(params, @user.id)
    @full_recipes_created = Recipe.full_recipes(created_recipes, @user.id)

    @num_liked = RecipeUser.num_liked_created_recipes_by_user_id(@user.id)
    @num_disliked = RecipeUser.num_disliked_created_recipes_by_user_id(@user.id)
    @num_favorited = RecipeUser.num_favorited_created_recipes_by_user_id(@user.id)

    @follower_users = UserFollow.followers(@user.id)
    @following_users = UserFollow.following(@user.id)

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
