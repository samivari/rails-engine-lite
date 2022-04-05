class Invoice < ApplicationRecord
  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  def self.unshipped_rev
    joins(invoice_items: { invoice: :transactions }).where(transactions: { result: 'success' },
                                                           invoices: { status: 'pending' })
                                                    .sum('invoice_items.quantity * invoice_items.unit_price')
  end
end
