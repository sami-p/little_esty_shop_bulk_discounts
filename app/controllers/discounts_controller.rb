class DiscountsController < ApplicationController

  def index
    @discounts = Discount.all
  end
end
