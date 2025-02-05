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

  def apply_discount?
    merchant = Merchant.where("id = ?", item.merchant_id)
    if merchant.first.discounts.empty?
      false
    else
      self.quantity >= merchant.first.discounts.minimum(:quantity_threshold)
    end
  end

  def select_discount
    merchant = Merchant.where("id = ?", item.merchant_id).first
    merchant.discounts.where("quantity_threshold <= ?", self.quantity).order('percent DESC').first
  end
end
