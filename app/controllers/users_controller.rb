class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i[my_portfolio friends]

  def show
    @user = User.find params[:id]
    @tracked_stocks = @user.stocks
  end

  def my_portfolio
    @tracked_stocks = current_user.stocks
  end

  def my_friends
    @friends = current_user.friends
  end
    
  def search
    if params[:friend].present?
      @friends = User.search_friends params[:friend]

      respond_to do |format|
        format.js { render partial: 'users/friend' }
      end
    end
  end
end
