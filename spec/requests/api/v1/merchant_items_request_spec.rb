require 'rails_helper'
RSpec.describe 'merchant items request spec' do
  let!(:merchant_1) { Merchant.create!(name: 'Primal Peas') }

  let!(:item_1) { merchant_1.items.create!(name: 'Big Pea', description: 'Its a big pea', unit_price: 2) }
  let!(:item_2) { merchant_1.items.create!(name: 'Little Pea', description: 'Its a little pea', unit_price: 10) }

  it 'get all items for a given merchant ID' do
    get "/api/v1/merchants/#{merchant_1.id}/items"

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items.count).to eq(2)

    items.each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(Integer)

      expect(item).to have_key(:name)
      expect(item[:name]).to be_a(String)

      expect(item).to have_key(:description)
      expect(item[:description]).to be_a(String)

      expect(item).to have_key(:unit_price)
      expect(item[:unit_price]).to be_a(Float)

      expect(item).to have_key(:merchant_id)
      expect(item[:merchant_id]).to be_an(Integer)
    end
  end
end
