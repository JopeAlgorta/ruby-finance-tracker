class StocksController < ApplicationController
  before_action :authenticate_user!

  def search
    if params[:stock].present?
      @stock = Stock.new_lookup params[:stock]

      respond_to do |format|
        format.js { render partial: 'users/result' }
      end
    end
  end
end
