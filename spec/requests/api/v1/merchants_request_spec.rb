require 'rails_helper'

RSpec.describe 'Merchants API' do
  it 'sends a list of merchants' do
    create_list(:merchant, 5)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants.count).to eq(5)

    merchants.each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_a(Integer)

      expect(merchant).to have_key(:name)
      expect(merchant[:name]).to be_a(String)
    end
  end

  it 'sends info for a single merchant' do
    merchant_1 = Merchant.create!(name: 'Primal Peas')
    get "/api/v1/merchants/#{merchant_1.id}"

    expect(response).to be_successful

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(merchant).to have_key(:id)
    expect(merchant[:id]).to be_a(Integer)

    expect(merchant).to have_key(:name)
    expect(merchant[:name]).to be_a(String)
    expect(merchant[:name]).to eq('Primal Peas')
  end
end
