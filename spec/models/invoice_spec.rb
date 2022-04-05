require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'relationships' do
    it { should belong_to(:customer) }
    it { should have_many(:transactions) }

    it { should have_many(:invoice_items) }
    it { should have_many(:items).through(:invoice_items) }
  end

  describe 'class methods' do
    it 'finds total revenue of unshipped' do
      merchant_1 = Merchant.create!(name: "Billy's Pet Rocks")
      item_1 = merchant_1.items.create!(name: 'Obsidian Nobice', description: 'A beautiful obsidian', unit_price: 0)
      item_2 = merchant_1.items.create!(name: 'Green Obsidian Cup', description: 'An obsidian cup', unit_price: 0)
      item_3 = merchant_1.items.create!(name: 'Dirt', description: 'dirt', unit_price: 0)
      customer_1 = Customer.create!(first_name: 'Billy', last_name: 'Carruthurs')
      invoice_1 = customer_1.invoices.create!(customer_id: 1, status: 'pending')
      invoice_item_1 = InvoiceItem.create!(item_id: item_1.id, invoice_id: invoice_1.id, quantity: 1, unit_price: 1)
      invoice_item_2 = InvoiceItem.create!(item_id: item_2.id, invoice_id: invoice_1.id, quantity: 1, unit_price: 1)
      invoice_item_3 = InvoiceItem.create!(item_id: item_3.id, invoice_id: invoice_1.id, quantity: 1, unit_price: 1)
      transaction_1 = Transaction.create!(invoice_id: invoice_1.id, credit_card_number: '4',
                                          credit_card_expiration_date: '3', result: 'success')
      expect(Invoice.unshipped_rev).to eq(3)
    end
  end
end
