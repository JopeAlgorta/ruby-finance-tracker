class UserStocksController < ApplicationController
  def create
    ticker = params[:ticker] 
    stock = Stock.check_db ticker

    if stock.blank?
      stock = Stock.new_lookup ticker
      stock.save
    end 
    if current_user.can_track? ticker
      new_stock = current_user.user_stocks.build stock_id: stock.id
      if new_stock.save
        flash[:notice] = "Stock #{stock.name} was successfully added to your portfolio."
      end
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

  def copy
    stock = Stock.find params[:id]
    if current_user.can_track? stock.ticker
      new_stock = current_user.user_stocks.build stock_id: stock.id
      if new_stock.save
        flash[:notice] = "Stock #{stock.name} was successfully added to your portfolio."
      end
    else
      flash[:alert] = "Maximum number of tracked stocks reached! Consider removing some to add this one."
    end
    redirect_back(fallback_location: root_path)
  end
end
