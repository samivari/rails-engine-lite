class Merchant < ApplicationRecord
  has_many :items
  has_many :invoices, through: :items
  has_many :invoice_items, through: :items
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices

  def self.total_revenue(merchant_id)
    joins(:transactions).where(merchants: { id: merchant_id }, transactions: { result: 'success' })
                        .group(:id)
                        .select('SUM(invoice_items.quantity * invoice_items.unit_price) as revenue')
                        .first.revenue
  end
end
