class Stock < ApplicationRecord
  has_many :user_stocks
  has_many :users, through: :user_stocks 

  validates :name, presence: true
  validates :ticker, presence: true

  def self.new_lookup ticker
    client = IEX::Api::Client.new(
      publishable_token: Rails.application.credentials.iex[:publishable_token],
      secret_token: Rails.application.credentials.iex[:secret_token],
      endpoint: Rails.application.credentials.iex[:endpoint]
    )
    begin
      name = client.company(ticker).company_name
      last_price = client.price(ticker)
      new ticker: ticker.upcase, name: name, last_price: last_price
    rescue => exception
      nil
    end
  end

  def self.check_db ticker
    find_by ticker: ticker 
  end
end
