require 'rails_helper'

RSpec.describe Suppliers::SearchService do
  subject { service.call }

  let(:service) { described_class.new(params: params) }
  let!(:supplier1) { create(:supplier) }
  let!(:supplier2) { create(:supplier) }
  let!(:supplier3) { create(:supplier) }
  let(:params) do
    {
      checkin: '20191201',
      checkout: '20191231',
      destination: 'Singapore',
      guest: 1,
      suppliers: suppliers
    }.with_indifferent_access
  end

  describe '#call' do
    context 'suppliers parameter is empty' do
      let(:memory_store) { ActiveSupport::Cache.lookup_store(:redis_cache_store) }
      let(:cache) { Rails.cache }
      let(:suppliers) { '' }
      let(:response) do
        [
          ["abcd", 100, "supplier1"],
          ["defg", 200, "supplier2"],
          ["mnop", 300, "supplier3"]
        ]
      end
      let(:hotels) do
        [
          {"id" => "abcd", "price" => 100, "supplier" => "supplier1"},
          {"id" => "defg", "price" => 200, "supplier" => "supplier2"},
          {"id" => "mnop", "price" => 300, "supplier" => "supplier3"}
        ]
      end

      before do
        allow(service).to receive(:fetch_cheapest_hotels).and_return(response)
        allow(Rails).to receive(:cache).and_return(memory_store)
        Rails.cache.clear
      end

      it 'returns result from all suppliers' do
        subject
        expect(service.hotels).to eq hotels
        expect(cache.exist?(params.values.join('_'))).to eq true
      end
    end

    context 'suppliers parameter is supplier1' do
      let(:memory_store) { ActiveSupport::Cache.lookup_store(:redis_cache_store) }
      let(:cache) { Rails.cache }
      let(:suppliers) { 'supplier1' }
      let(:response) do
        [
          ["abcd", 100, "supplier1"]
        ]
      end
      let(:hotels) do
        [
          {"id" => "abcd", "price" => 100, "supplier" => "supplier1"}
        ]
      end

      before do
        allow(service).to receive(:fetch_cheapest_hotels).and_return(response)
        allow(Rails).to receive(:cache).and_return(memory_store)
        Rails.cache.clear
      end

      it 'returns result from supplier1' do
        subject
        expect(service.hotels).to eq hotels
        expect(cache.exist?(params.values.join('_'))).to eq true
      end
    end

    context 'suppliers parameter is supplier1,supplier3' do
      let(:memory_store) { ActiveSupport::Cache.lookup_store(:redis_cache_store) }
      let(:cache) { Rails.cache }
      let(:suppliers) { 'supplier1,supplier3' }
      let(:response) do
        [
          ["abcd", 100, "supplier1"],
          ["mnop", 300, "supplier3"]
        ]
      end
      let(:hotels) do
        [
          {"id" => "abcd", "price" => 100, "supplier" => "supplier1"},
          {"id" => "mnop", "price" => 300, "supplier" => "supplier3"}
        ]
      end

      before do
        allow(service).to receive(:fetch_cheapest_hotels).and_return(response)
        allow(Rails).to receive(:cache).and_return(memory_store)
        Rails.cache.clear
      end

      it 'returns result from both supplier1 and supplier3' do
        subject
        expect(service.hotels).to eq hotels
        expect(cache.exist?(params.values.join('_'))).to eq true
      end
    end
  end
end
