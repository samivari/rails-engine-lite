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

    expect(all_items[:data].count).to eq(6)

    all_items[:data].each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(String)

      expect(item).to have_key(:type)
      expect(item[:type]).to eq('item')

      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)

      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)

      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a(Float)

      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to be_an(Integer)
    end
  end

  it 'sends info for a single item' do
    merchants = create_list(:merchant, 1)
    item = create(:item, merchant_id: merchants.first.id)

    get "/api/v1/items/#{item.id}"

    expect(response).to be_successful

    item = JSON.parse(response.body, symbolize_names: true)

    expect(item[:data]).to have_key(:id)
    expect(item[:data][:id]).to be_a(String)
    expect(item[:data][:attributes]).to have_key(:name)
    expect(item[:data][:attributes][:name]).to be_a(String)
    expect(item[:data][:attributes]).to have_key(:description)
    expect(item[:data][:attributes][:description]).to be_a(String)
    expect(item[:data][:attributes]).to have_key(:unit_price)
    expect(item[:data][:attributes][:unit_price]).to be_a(Float)
    expect(item[:data][:attributes]).to have_key(:merchant_id)
    expect(item[:data][:attributes][:merchant_id]).to be_an(Integer)
  end

  it 'create an item' do
    expect(Item.all.count).to eq(0)
    merchant = create(:merchant)
    post '/api/v1/items',
         params: { name: 'New Item', description: 'Its an item', unit_price: 12, merchant_id: merchant.id }
    expect(Item.all.count).to eq(1)
  end

  it 'can edit an item' do
    merchant = create(:merchant)
    item = create(:item, name: 'Cheese', merchant_id: merchant.id)
    patch "/api/v1/items/#{item.id}", params: { name: 'Chicken' }
    item = JSON.parse(response.body, symbolize_names: true)

    expect(item[:data][:attributes][:name]).to eq('Chicken')
  end

  it 'sends info to delete a item' do
    merchant = create(:merchant)
    create_list(:item, 6, merchant_id: merchant.id)
    expect(Item.count).to eq(6)
    item = Item.all.first

    delete "/api/v1/items/#{item.id}"

    expect(response).to be_successful
    expect(Item.count).to eq(5)
    expect { Item.find(item.id) }.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'get an items merchant' do
    merchant = create(:merchant, name: 'Primal Peas')
    item = create(:item, merchant_id: merchant.id)
    get "/api/v1/items/#{item.id}/merchant"

    expect(response).to be_successful

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(merchant[:data][:type]).to eq('merchant')
    expect(merchant[:data][:id]).to be_a(String)
    expect(merchant[:data][:attributes][:name]).to eq('Primal Peas')
  end

  it 'sad path for a single item' do
    merchant = create(:merchant)
    id = 181_818_181

    get "/api/v1/items/#{id}"

    expect(response).to_not be_successful
    sad_response = JSON.parse(response.body, symbolize_names: true)
    expect(sad_response[:error][:message]).to eq("Couldn't find Item with 'id'=181818181")
  end
end
