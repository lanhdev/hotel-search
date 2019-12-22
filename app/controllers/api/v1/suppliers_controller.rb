module Api
  module V1
    class SuppliersController < ::ApplicationController
      def search
        service = Suppliers::SearchService.new(
          params: search_params
        ).tap(&:call)

        render json: service.hotels,
               status: :ok
      end

      private

      def search_params
        params.permit(
          :checkin,
          :checkout,
          :destination,
          :guests,
          :suppliers
        )
      end
    end
  end
end
