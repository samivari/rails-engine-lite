require 'rails_helper'

RSpec.describe 'Merchants API' do
  it 'sends a list of merchants' do
    create_list(:merchant, 5)

    get '/api/v1/merchants'

    expect(response).to be_successful

    parsed_response = JSON.parse(response.body, symbolize_names: true)

    merchants = parsed_response[:data]

    expect(merchants.count).to eq(5)

    merchants.each do |merchant|
      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
    end
  end

  it 'sends info for a single merchant' do
    merchant = create(:merchant, name: 'Primal Peas')

    get "/api/v1/merchants/#{merchant.id}"

    expect(response).to be_successful

    parsed_response = JSON.parse(response.body, symbolize_names: true)

    expect(parsed_response[:data][:type]).to eq('merchant')
    expect(parsed_response[:data][:id]).to be_a(String)
    expect(parsed_response[:data][:attributes][:name]).to eq('Primal Peas')
  end
end
