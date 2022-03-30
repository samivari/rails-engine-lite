require 'rails_helper'

RSpec.describe 'Item API' do
  it 'sends a list of items' do
    merchants = create_list(:merchant, 3)
    merchant_1_items = 3.times do
      create(:item, merchant_id: merchants.first.id)
    end
    merchant_2_items = 2.times do
      create(:item, merchant_id: merchants.second.id)
    end
    merchant_3_items = 1.times do
      create(:item, merchant_id: merchants.third.id)
    end

    get '/api/v1/items'

    expect(response).to be_successful

    all_items = JSON.parse(response.body, symbolize_names: true)

    expect(all_items.count).to eq(6)

    all_items.each do |item|
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

  it 'sends info for a single item' do
    merchants = create_list(:merchant, 1)
    item = create(:item, merchant_id: merchants.first.id)

    get "/api/v1/items/#{item.id}"

    expect(response).to be_successful

    item = JSON.parse(response.body, symbolize_names: true)

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
