@discount_1 = Discount.create!(percent: 20, quantity_threshold: 10, merchant_id: 1)
@discount_2 = Discount.create!(percent: 10, quantity_threshold: 5, merchant_id: 1)
@discount_3 = Discount.create!(percent: 15, quantity_threshold: 15, merchant_id: 1)
@discount_4 = Discount.create!(percent: 30, quantity_threshold: 5, merchant_id: 2)
@discount_5 = Discount.create!(percent: 35, quantity_threshold: 10, merchant_id: 2)
@discount_6 = Discount.create!(percent: 12, quantity_threshold: 12, merchant_id: 3)
@discount_7 = Discount.create!(percent: 10, quantity_threshold: 2, merchant_id: 3)
@discount_8 = Discount.create!(percent: 25, quantity_threshold: 10, merchant_id: 4)
@discount_9 = Discount.create!(percent: 30, quantity_threshold: 15, merchant_id: 4)
