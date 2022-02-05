class Stock < ApplicationRecord

  def self.new_lookup ticker
    client = IEX::Api::Client.new(
      publishable_token: Rails.application.credentials.iex[:publishable_token],
      secret_token: Rails.application.credentials.iex[:secret_token],
      endpoint: Rails.application.credentials.iex[:endpoint]
    )
    
    name = client.company(ticker).company_name
    last_price = client.price(ticker)

    new ticker: ticker, name: name, last_price: last_price
  end

end
