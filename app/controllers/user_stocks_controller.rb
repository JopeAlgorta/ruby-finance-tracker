class UserStocksController < ApplicationController
  def create
    ticker = params[:ticker] 
    stock = Stock.check_db ticker

    if stock.blank?
      stock = Stock.new_lookup ticker
      stock.save
    end 
    if current_user.can_track? ticker
      @user_stock = UserStock.create user: current_user, stock: stock
      flash[:notice] = "Stock #{stock.name} was successfully added to your portfolio."
    else
      flash[:alert] = "Maximum number of tracked stocks reached! Consider removing some to add this one."
    end
    redirect_to portfolio_path
  end

  def destroy
    stock = Stock.find params[:id]
    user_stock = UserStock.find_by(stock_id: stock.id, user_id: current_user.id)

    if user_stock.destroy
      redirect_to portfolio_path, notice: "Stock #{stock.name} removed from your portfolio."
    end
  end
end
