class Price < ActiveHash::Base
  self.data = [
    { id: 1, amount: 2200, currency: 'jpy', tickets: 1, stripe_price_id: 'price_1Jy6AaCGxjuXgfl899ypkuLS' },
    { id: 2, amount: 5500, currency: 'jpy', tickets: 3, stripe_price_id: 'price_1Jy6BJCGxjuXgfl84dBeyWZW' },
    { id: 3, amount: 8250, currency: 'jpy', tickets: 5, stripe_price_id: 'price_1Jy6BlCGxjuXgfl8EtZkCX31' }
  ]

  def name
    "チケット#{tickets}枚: #{amount}(#{currency})"
  end
end
