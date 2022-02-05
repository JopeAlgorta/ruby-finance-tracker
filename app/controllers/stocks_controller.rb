class StocksController < ApplicationController
  def search
    @stock = Stock.new_lookup params[:stock]

    if !@stock.nil?
      render 'users/my_portfolio'
    end
  end
end
