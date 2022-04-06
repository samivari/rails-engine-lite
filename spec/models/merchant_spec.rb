require 'rails_helper'

RSpec.describe Merchant, type: :model do
  it 'exists' do
    merchant_1 = Merchant.create!(name: 'Billys Pet Rocks')
    expect(merchant_1).to be_a(Merchant)
  end

  describe 'relationships' do
    it { should have_many(:items) }
    it { should have_many(:invoices).through(:items) }
    it { should have_many(:invoice_items).through(:items) }
    it { should have_many(:transactions).through(:invoices) }
    it { should have_many(:customers).through(:invoices) }
  end

  describe 'class methods' do
    it 'gets the total revenue for one merchant' do
      merchant_1 = Merchant.create!(name: "Billy's Pet Rocks")
      item_1 = merchant_1.items.create!(name: 'Obsidian Nobice', description: 'A beautiful obsidian', unit_price: 0)
      item_2 = merchant_1.items.create!(name: 'Green Obsidian Cup', description: 'An obsidian cup', unit_price: 0)
      item_3 = merchant_1.items.create!(name: 'Dirt', description: 'dirt', unit_price: 0)
      customer_1 = Customer.create!(first_name: 'Billy', last_name: 'Carruthurs')
      invoice_1 = customer_1.invoices.create!(customer_id: 1, status: 'shipped')
      invoice_item_1 = InvoiceItem.create!(item_id: item_1.id, invoice_id: invoice_1.id, quantity: 1, unit_price: 1)
      invoice_item_2 = InvoiceItem.create!(item_id: item_2.id, invoice_id: invoice_1.id, quantity: 1, unit_price: 1)
      invoice_item_3 = InvoiceItem.create!(item_id: item_3.id, invoice_id: invoice_1.id, quantity: 1, unit_price: 1)
      transaction_1 = Transaction.create!(invoice_id: invoice_1.id, credit_card_number: '4',
                                          credit_card_expiration_date: '3', result: 'success')
      expect(Merchant.total_revenue(merchant_1.id)).to eq(3.0)
    end
  end
end
