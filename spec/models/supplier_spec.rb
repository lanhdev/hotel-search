require 'rails_helper'

RSpec.describe Supplier do
  describe '#find_cheapest_hotel' do
    let(:supplier) { create(:supplier) }
    let(:response) { double(body: '') }
    let(:response_body) do
      { "abcd": 300, "defg": 400, "mnop": 250 }.with_indifferent_access
    end

    subject { supplier.find_cheapest_hotel }

    before do
      expect(Net::HTTP).to receive(:get_response).and_return(response)
      expect(JSON).to receive(:parse).and_return(response_body)
    end

    it 'returns cheapest hotel' do
      is_expected.to eq ["mnop", 250, supplier.name.to_s]
    end
  end
end
