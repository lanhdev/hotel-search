module Suppliers
  class SearchService
    CACHE_EXPIRES_IN = 5.minutes

    attr_reader :hotels

    def initialize(params:)
      @params = params
    end

    def call
      fetch_from_cache
    end

    private

    attr_reader :params

    def fetch_from_cache
      @hotels = Rails.cache.fetch(cache_key, expires_in: CACHE_EXPIRES_IN) do
        hotels = fetch_cheapest_hotels
        hotels.map { |hotel| [attributes, hotel].transpose.to_h }
      end
    end

    def fetch_cheapest_hotels
      suppliers.map(&:find_cheapest_hotel)
    end

    def suppliers
      suppliers_param = params.dig(:suppliers).split(',')

      @suppliers ||=
        if suppliers_param.empty?
          Supplier.all
        else
          Supplier.where(name: suppliers_param)
        end
    end

    def cache_key
      params.values.join('_')
    end

    def attributes
      %w(id price supplier)
    end
  end
end
