require 'rails_helper'

RSpec.describe 'Bulk Discounts Index page' do
  before :each do
    @merchant1 = Merchant.create!(name: 'Hair Care')

    @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
    @customer_2 = Customer.create!(first_name: 'Cecilia', last_name: 'Jones')
    @customer_3 = Customer.create!(first_name: 'Mariah', last_name: 'Carrey')
    @customer_4 = Customer.create!(first_name: 'Leigh Ann', last_name: 'Bron')
    @customer_5 = Customer.create!(first_name: 'Sylvester', last_name: 'Nader')
    @customer_6 = Customer.create!(first_name: 'Herber', last_name: 'Coon')

    @invoice_1 = Invoice.create!(customer_id: @customer_1.id, status: 2)
    @invoice_2 = Invoice.create!(customer_id: @customer_1.id, status: 2)
    @invoice_3 = Invoice.create!(customer_id: @customer_2.id, status: 2)
    @invoice_4 = Invoice.create!(customer_id: @customer_3.id, status: 2)
    @invoice_5 = Invoice.create!(customer_id: @customer_4.id, status: 2)
    @invoice_6 = Invoice.create!(customer_id: @customer_5.id, status: 2)
    @invoice_7 = Invoice.create!(customer_id: @customer_6.id, status: 1)

    @item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: @merchant1.id)
    @item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: @merchant1.id)
    @item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: @merchant1.id)
    @item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: @merchant1.id)

    @ii_1 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0)
    @ii_2 = InvoiceItem.create!(invoice_id: @invoice_1.id, item_id: @item_2.id, quantity: 1, unit_price: 8, status: 0)
    @ii_3 = InvoiceItem.create!(invoice_id: @invoice_2.id, item_id: @item_3.id, quantity: 1, unit_price: 5, status: 2)
    @ii_4 = InvoiceItem.create!(invoice_id: @invoice_3.id, item_id: @item_4.id, quantity: 1, unit_price: 5, status: 1)

    @transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_1.id)
    @transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: @invoice_3.id)
    @transaction3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: @invoice_4.id)
    @transaction4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: @invoice_5.id)
    @transaction5 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: @invoice_6.id)
    @transaction6 = Transaction.create!(credit_card_number: 879799, result: 1, invoice_id: @invoice_7.id)
    @transaction7 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: @invoice_2.id)

    @discount_1 = @merchant1.discounts.create!(percent: 10, quantity_threshold: 5)
    @discount_2 = @merchant1.discounts.create!(percent: 15, quantity_threshold: 10)
    @discount_3 = @merchant1.discounts.create!(percent: 20, quantity_threshold: 15)
    @discount_4 = @merchant1.discounts.create!(percent: 25, quantity_threshold: 20)

    visit "/merchant/#{@merchant1.id}/discounts"
  end

  # As a merchant
  # When I visit my merchant dashboard
  # Then I see a link to view all my discounts
  # When I click this link
  # Then I am taken to my bulk discounts index page
  # Where I see all of my bulk discounts including their
  # percentage discount and quantity thresholds
  # And each bulk discount listed includes a link to its show page

  it 'displays each discount percentage and quantity threshold' do
    expect(page).to have_content(@discount_1.percent)
    expect(page).to have_content(@discount_1.quantity_threshold)

    expect(page).to have_content(@discount_2.percent)
    expect(page).to have_content(@discount_2.quantity_threshold)

    expect(page).to have_content(@discount_3.percent)
    expect(page).to have_content(@discount_3.quantity_threshold)

    expect(page).to have_content(@discount_4.percent)
    expect(page).to have_content(@discount_4.quantity_threshold)
  end

  it 'includes a link to each discount show page' do
    expect(page).to have_link("Shop #{@discount_1.percent}% Off")
    expect(page).to have_link("Shop #{@discount_2.percent}% Off")
    expect(page).to have_link("Shop #{@discount_3.percent}% Off")
    expect(page).to have_link("Shop #{@discount_4.percent}% Off")

    click_link "Shop #{@discount_3.percent}% Off"

    expect(current_path).to eq("/merchant/#{@merchant1.id}/discounts/#{@discount_3.id}")
  end

  # As a merchant
  # When I visit the discounts index page
  # I see a section with a header of "Upcoming Holidays"
  # In this section the name and date of the next 3 upcoming US holidays are listed.
  #
  # Use the Next Public Holidays Endpoint in the [Nager.Date API](https://date.nager.at/swagger/index.html)

  xit 'displays an Upcoming Holidays section with name and date of 3 holidays' do
    expect(page).to have_content("Upcoming Holidays")
    # curl -X GET "https://date.nager.at/api/v2/NextPublicHolidays/US" -H  "accept: text/plain"
    # https://date.nager.at/api/v2/NextPublicHolidays/US
  end

  # As a merchant
  # When I visit my bulk discounts index
  # Then I see a link to create a new discount
  # When I click this link
  # Then I am taken to a new page where I see a form to add a new bulk discount
  # When I fill in the form with valid data
  # Then I am redirected back to the bulk discount index
  # And I see my new bulk discount listed

  it 'displays a link to create a new discount' do
    click_link "Create New Discount"

    expect(current_path).to eq(new_merchant_discount_path(@merchant1))

    fill_in "Percent", with: 30
    fill_in "Quantity Threshold", with: 25
    click_button "Add Discount"

    expect(current_path).to eq("/merchant/#{@merchant1.id}/discounts")
    expect(page).to have_content("Shop 30% Off 25 items")
  end

  it 'will not accept new discount without valid data' do
    click_link "Create New Discount"

    fill_in "Quantity Threshold", with: "Hello"

    click_button "Add Discount"

    expect(current_path).to eq(new_merchant_discount_path(@merchant1))
    expect(page).to have_content("We kindly ask that you fill out the form with the correct information before submitting.")
  end

  it 'will not accept new discount if percent is 0' do
    click_link "Create New Discount"

    fill_in "Percent", with: 0
    fill_in "Quantity Threshold", with: 10

    click_button "Add Discount"

    expect(current_path).to eq(new_merchant_discount_path(@merchant1))
    expect(page).to have_content("We kindly ask that you fill out the form with the correct information before submitting.")
  end

  # As a merchant
  # When I visit my bulk discounts index
  # Then next to each bulk discount I see a link to delete it
  # When I click this link
  # Then I am redirected back to the bulk discounts index page
  # And I no longer see the discount listed

  it 'displays a link per discount to delete that discount' do
    expect(page).to have_link("Delete #{@discount_1.percent}% Discount")
    expect(page).to have_link("Delete #{@discount_2.percent}% Discount")
    expect(page).to have_link("Delete #{@discount_3.percent}% Discount")
    expect(page).to have_link("Delete #{@discount_4.percent}% Discount")

    click_link "Delete #{@discount_3.percent}% Discount"
    
    expect(current_path).to eq("/merchant/#{@merchant1.id}/discounts")
    expect(page).to_not have_content("Shop #{@discount_3.percent}% Off")
  end
end
