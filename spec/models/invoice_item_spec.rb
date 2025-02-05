require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe "validations" do
    it { should validate_presence_of :invoice_id }
    it { should validate_presence_of :item_id }
    it { should validate_presence_of :quantity }
    it { should validate_presence_of :unit_price }
    it { should validate_presence_of :status }
  end
  describe "relationships" do
    it { should belong_to :invoice }
    it { should belong_to :item }
  end

  describe 'discount methods' do
    before :each do
      @merchant1 = Merchant.create!(name: 'Hair Care')
      @merchant2 = Merchant.create!(name: 'Jewelry')

      @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id, status: 1)
      @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant1.id)
      @item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant1.id)
      @item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @merchant1.id)
      @item_7 = Item.create!(name: "Scrunchie", description: "This holds up your hair but is bigger", unit_price: 3, merchant_id: @merchant1.id)
      @item_8 = Item.create!(name: "Butterfly Clip", description: "This holds up your hair but in a clip", unit_price: 5, merchant_id: @merchant1.id)

      @item_5 = Item.create!(name: "Bracelet", description: "Wrist bling", unit_price: 200, merchant_id: @merchant2.id)
      @item_6 = Item.create!(name: "Necklace", description: "Neck bling", unit_price: 300, merchant_id: @merchant2.id)

      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
      @customer_2 = Customer.create!(first_name: 'Cecilia', last_name: 'Jones')
      @customer_3 = Customer.create!(first_name: 'Mariah', last_name: 'Carrey')
      @customer_4 = Customer.create!(first_name: 'Leigh Ann', last_name: 'Bron')
      @customer_5 = Customer.create!(first_name: 'Sylvester', last_name: 'Nader')
      @customer_6 = Customer.create!(first_name: 'Herber', last_name: 'Coon')

      @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-27 14:54:09")
      @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2, created_at: "2012-03-28 14:54:09")
      @invoice_3 = Invoice.create!(customer_id: @customer_2.id, status: 2)
      @invoice_4 = Invoice.create!(customer_id: @customer_3.id, status: 2)
      @invoice_5 = Invoice.create!(customer_id: @customer_4.id, status: 2)
      @invoice_6 = Invoice.create!(customer_id: @customer_5.id, status: 2)
      @invoice_7 = Invoice.create!(customer_id: @customer_6.id, status: 2)

      @invoice_8 = Invoice.create!(customer_id: @customer_6.id, status: 1)

      @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 5, unit_price: 10, status: 2)
      @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 5, unit_price: 10, status: 2)
      @ii_3 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_2.id, quantity: 10, unit_price: 8, status: 2)
      @ii_4 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_3.id, quantity: 5, unit_price: 5, status: 1)

      @ii_6 = InvoiceItem.create!(invoice_id: @invoice_5.id, item_id: @item_4.id, quantity: 12, unit_price: 1, status: 1)
      @ii_7 = InvoiceItem.create!(invoice_id: @invoice_5.id, item_id: @item_7.id, quantity: 15, unit_price: 3, status: 1)

      @ii_8 = InvoiceItem.create!(invoice_id: @invoice_7.id, item_id: @item_8.id, quantity: 10, unit_price: 5, status: 1)
      @ii_9 = InvoiceItem.create!(invoice_id: @invoice_7.id, item_id: @item_4.id, quantity: 12, unit_price: 1, status: 1)

      @ii_10 = InvoiceItem.create!(invoice_id: @invoice_8.id, item_id: @item_5.id, quantity: 1, unit_price: 1, status: 1)
      @ii_11 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_8.id, quantity: 1, unit_price: 6, status: 1)

      @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_1.id)
      @transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @invoice_2.id)
      @transaction3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: @invoice_3.id)
      @transaction4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: @invoice_4.id)
      @transaction5 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @invoice_5.id)
      @transaction6 = Transaction.create!(credit_card_number: 879799, result: 0, invoice_id: @invoice_6.id)
      @transaction7 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_7.id)
      @transaction8 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_8.id)
    end

    # Merchant A has one Bulk Discount
    # Bulk Discount A is 20% off 10 items
    # Invoice A includes two of Merchant A’s items
    # Item A is ordered in a quantity of 5
    # Item B is ordered in a quantity of 5

    it 'finds if discount applies for invoice 1 / example 1' do
      discount_1 = @merchant1.discounts.create!(percent: 20, quantity_threshold: 10)
      discount_2 = @merchant1.discounts.create!(percent: 30, quantity_threshold: 15)

      expect(@ii_1.apply_discount?).to eq(false)
      expect(@ii_2.apply_discount?).to eq(false)
    end

    # Merchant A has one Bulk Discount
    # Bulk Discount A is 20% off 10 items
    # Invoice A includes two of Merchant A’s items
    # Item A is ordered in a quantity of 10
    # Item B is ordered in a quantity of 5

    it 'finds select items that meet discount threshold / example 2' do
      discount_1 = @merchant1.discounts.create!(percent: 20, quantity_threshold: 10)
      discount_2 = @merchant1.discounts.create!(percent: 30, quantity_threshold: 15)

      expect(@ii_3.apply_discount?).to eq(true)
      expect(@ii_4.apply_discount?).to eq(false)
    end

    # Merchant A has two Bulk Discounts
    # Bulk Discount A is 20% off 10 items
    # Bulk Discount B is 30% off 15 items
    # Invoice A includes two of Merchant A’s items
    # Item A is ordered in a quantity of 12
    # Item B is ordered in a quantity of 15

    # In this example, Item A should discounted at 20% off, and Item B should discounted at 30% off.

    it 'filters chosen discount to highest discount when multiple thresholds are met' do
      discount_1 = @merchant1.discounts.create!(percent: 20, quantity_threshold: 10)
      discount_2 = @merchant1.discounts.create!(percent: 30, quantity_threshold: 15)

      expect(@ii_6.apply_discount?).to eq(true)
      expect(@ii_7.apply_discount?).to eq(true)

      expect(@ii_6.select_discount).to eq(discount_1)
      expect(@ii_7.select_discount).to eq(discount_2)
    end


    # Merchant A has two Bulk Discounts
    # Bulk Discount A is 20% off 10 items
    # Bulk Discount B is 15% off 15 items
    # Invoice A includes two of Merchant A’s items
    # Item A is ordered in a quantity of 12
    # Item B is ordered in a quantity of 15
    # In this example, Both Item A and Item B should discounted at 20% off. Additionally, there is no scenario where Bulk Discount B can ever be applied

    it 'applies highest discount based on percent if multiple thresholds are met' do
      discount_1 = @merchant1.discounts.create!(percent: 20, quantity_threshold: 10)
      discount_3 = @merchant1.discounts.create!(percent: 15, quantity_threshold: 15)

      expect(@ii_8.apply_discount?).to eq(true)
      expect(@ii_9.apply_discount?).to eq(true)
      expect(@ii_11.apply_discount?).to eq(false)

      expect(@ii_8.select_discount).to eq(discount_1)
      expect(@ii_9.select_discount).to eq(discount_1)
    end
  end
end
