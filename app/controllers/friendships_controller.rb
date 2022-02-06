class FriendshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    friend = User.find params[:id]

    if friend and current_user != friend
      current_user.friendships.build friend_id: friend.id
      if current_user.save
        redirect_back(fallback_location: root_path, notice: "#{friend.first_name || friend.last_name || friend.email} was added to your friends list!")
      end
    else
      redirect_back(fallback_location: root_path, alert: "That user doesn't exists.") if not friend
      redirect_back(fallback_location: root_path, alert: "You cannot follow yourself.") if current_user == friend
    end
  end

  def destroy
    friend = User.find params[:id]
    friendship = current_user.friendships.find_by(friend_id: friend.id)

    if friendship.destroy
      redirect_back(fallback_location: root_path, notice: "Friend unfollowed!")
    end
  end
end