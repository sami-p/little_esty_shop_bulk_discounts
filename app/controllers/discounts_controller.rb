class DiscountsController < ApplicationController

  def index
    @merchant = Merchant.find(params[:merchant_id])
    @discounts = @merchant.discounts.all
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @discount = Discount.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    @discount = @merchant.discounts.new(discount_params)
    if @discount.save
      redirect_to "/merchant/#{@merchant.id}/discounts"
    else
      flash[:alert] = "We kindly ask that you fill out the form with the correct information before submitting."
      redirect_to "/merchant/#{@merchant.id}/discounts/new"
    end
  end

  def edit
    @merchant = Merchant.find(params[:merchant_id])
    @discount = Discount.find(params[:id])
  end

  def update
    @merchant = Merchant.find(params[:merchant_id])
    @discount = Discount.find(params[:id])
    @discount.update(discount_params)
    if @discount.save
      redirect_to "/merchant/#{@merchant.id}/discounts/#{@discount.id}"
    else
      flash[:alert] = "Please make sure you have correctly editted your discount before submitting. Thank you!"
      redirect_to "/merchant/#{@merchant.id}/discounts/#{@discount.id}/edit"
    end
  end

  def destroy
    @merchant = Merchant.find(params[:merchant_id])
    @discount = @merchant.discounts.find(params[:id])
    @discount.destroy
    redirect_to "/merchant/#{@merchant.id}/discounts"
  end

  private
  def discount_params
    params.permit(:percent, :quantity_threshold)
  end
end
