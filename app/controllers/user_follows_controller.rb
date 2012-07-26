class UserFollowsController < ApplicationController
  before_filter :authenticate_user!

  def follow
    UserFollow.follow(current_user.id, params[:id])

    respond_to do |format|
      format.js { render :nothing => true }
    end
  end

  def unfollow
    UserFollow.unfollow(current_user.id, params[:id])

    respond_to do |format|
      format.js { render :nothing => true }
    end
  end



  #should probably just delete everything below...?

  # GET /user_follows
  # GET /user_follows.json
  def index
    @user_follows = UserFollow.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @user_follows }
    end
  end

  # GET /user_follows/1
  # GET /user_follows/1.json
  def show
    @user_follow = UserFollow.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user_follow }
    end
  end

  # GET /user_follows/new
  # GET /user_follows/new.json
  def new
    @user_follow = UserFollow.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user_follow }
    end
  end

  # GET /user_follows/1/edit
  def edit
    @user_follow = UserFollow.find(params[:id])
  end

  # POST /user_follows
  # POST /user_follows.json
  def create
    @user_follow = UserFollow.new(params[:user_follow])

    respond_to do |format|
      if @user_follow.save
        format.html { redirect_to @user_follow, notice: 'User follow was successfully created.' }
        format.json { render json: @user_follow, status: :created, location: @user_follow }
      else
        format.html { render action: "new" }
        format.json { render json: @user_follow.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /user_follows/1
  # PUT /user_follows/1.json
  def update
    @user_follow = UserFollow.find(params[:id])

    respond_to do |format|
      if @user_follow.update_attributes(params[:user_follow])
        format.html { redirect_to @user_follow, notice: 'User follow was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user_follow.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_follows/1
  # DELETE /user_follows/1.json
  def destroy
    @user_follow = UserFollow.find(params[:id])
    @user_follow.destroy

    respond_to do |format|
      format.html { redirect_to user_follows_url }
      format.json { head :no_content }
    end
  end
end
