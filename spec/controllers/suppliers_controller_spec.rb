require 'rails_helper'

RSpec.describe Api::V1::SuppliersController do
  describe 'GET /api/v1/suppliers/search' do
    subject do
      get :search, params: params
      response
    end

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
        subject
        is_expected.to have_http_status(:ok)
        expect(json).to eq hotels
        expect(json.size).to eq 3
      end
    end

    context 'suppliers parameter is supplier1' do
      let(:params) do
        {
          checkin: '20191201',
          checkout: '20191231',
          destination: 'Singapore',
          guest: 1,
          suppliers: 'supplier1'
        }.with_indifferent_access
      end
      let(:service) { double(hotels: '') }
      let(:hotels) do
        [
          {
            "id": "mnop",
            "price": 100,
            "supplier": "supplier1"
          }.with_indifferent_access
        ]
      end

      before do
        expect_any_instance_of(Suppliers::SearchService).to receive(:tap)
          .and_return(service)
        expect(service).to receive(:hotels).and_return(hotels)
      end

      it 'returns result from supplier1' do
        subject
        is_expected.to have_http_status(:ok)
        expect(json).to eq hotels
        expect(json.size).to eq 1
      end
    end

    context 'suppliers parameter is supplier1,supplier3' do
      let(:params) do
        {
          checkin: '20191201',
          checkout: '20191231',
          destination: 'Singapore',
          guest: 1,
          suppliers: 'supplier1,supplier3'
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
        subject
        is_expected.to have_http_status(:ok)
        expect(json).to eq hotels
        expect(json.size).to eq 2
      end
    end
  end
end
