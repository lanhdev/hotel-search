module Api
  module V1
    class SuppliersController < ::ApplicationController
      def search
        service = SearchService.new(params: search_params)

        if service.call
          render json: service.hotels,
                 status: :ok
        else
          render json: {
            _error: service.errors.full_messages.to_sentence,
            errors: service.errors.full_messages
          }, status: :unprocessable_entity
        end
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
