require 'net/http'

class Supplier < ApplicationRecord
  def find_cheapest_hotel
    uri = URI.parse(url)
    response = Net::HTTP.get_response(uri)
    JSON.parse(response.body).min_by { |hotel| hotel[1] } + [name]
  end
end
