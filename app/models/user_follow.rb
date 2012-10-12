class UserFollow < ActiveRecord::Base
    attr_accessible :follow_user_id, :user_id

    class << self
        def follow(user_id, follow_user_id)
            user_follow = UserFollow.find_or_initialize_by_user_id_and_follow_user_id(user_id, follow_user_id)
            user_follow.save
        end
        def unfollow(user_id, follow_user_id)
            user_follow = UserFollow.find_by_user_id_and_follow_user_id(user_id, follow_user_id)
            user_follow.destroy
        end

        def getFollowers(follow_user_id)
            user_followers = UserFollow.where(:follow_user_id => follow_user_id)
            return User.find(user_followers.collect{|u|u.user_id})
        end

        def getFollowing(user_id)
            user_follows = UserFollow.where(:user_id => user_id)
            # safe from user_ids that are no longer in the user table
            # TODO: delete these records when a user delete's their account.
            users = User.where("id IN (?)", user_follows.collect{|u|u.follow_user_id}.join(","))
        end
    end
end
