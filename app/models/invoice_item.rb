class InvoiceItem < ApplicationRecord
  validates_presence_of :invoice_id,
                        :item_id,
                        :quantity,
                        :unit_price,
                        :status

  belongs_to :invoice
  belongs_to :item

  enum status: [:pending, :packaged, :shipped]

  def self.incomplete_invoices
    invoice_ids = InvoiceItem.where("status = 0 OR status = 1").pluck(:invoice_id)
    Invoice.order(created_at: :asc).find(invoice_ids)
  end

  # invoice items
    # unit price
    # quantity
    # item_id

  # merchant
    # id

  # item
    # merchant_id

  # discount
    # percent
    # quantity threshold
    # merchant_id

  def apply_discount?
    merchant = Merchant.where("id = ?", item.merchant_id)
    self.quantity >= merchant.first.discounts.minimum(:quantity_threshold)
  end

  def select_discount
    merchant = Merchant.where("id = ?", item.merchant_id).first
    wip = merchant.discounts.where("quantity_threshold <= ?", self.quantity).order('percent DESC').first
  end
end
