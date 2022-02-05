class Stock < ApplicationRecord

  def self.new_lookup ticker
    client = IEX::Api::Client.new(
      publishable_token: Rails.application.credentials.iex[:publishable_token],
      secret_token: Rails.application.credentials.iex[:secret_token],
      endpoint: Rails.application.credentials.iex[:endpoint]
    )
    client.price(ticker)
  end

end
