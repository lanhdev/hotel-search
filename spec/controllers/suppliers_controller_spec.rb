require 'rails_helper'

RSpec.describe Api::V1::SuppliersController do
  describe 'GET /api/v1/suppliers/search' do
    context 'suppliers parameter is empty' do
      let(:params) do
        {
          checkin: '20191201',
          checkout: '20191231',
          destination: 'Singapore',
          guest: 1,
          suppliers: ''
        }.with_indifferent_access
      end
      let(:service) { double(hotels: '') }
      let(:hotels) do
        [
          {
            "id": "mnop",
            "price": 100,
            "supplier": "supplier1"
          }.with_indifferent_access,
          {
            "id": "abcd",
            "price": 150,
            "supplier": "supplier2"
          }.with_indifferent_access,
          {
            "id": "mnop",
            "price": 200,
            "supplier": "supplier3"
          }.with_indifferent_access
        ]
      end

      before do
        expect_any_instance_of(Suppliers::SearchService).to receive(:tap)
          .and_return(service)
        expect(service).to receive(:hotels).and_return(hotels)
      end

      it 'returns result from all suppliers' do
        get :search, params: params
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq hotels
      end
    end
  end
end
