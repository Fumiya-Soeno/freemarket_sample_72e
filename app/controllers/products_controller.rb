class ProductsController < ApplicationController
  before_action :set_params
  before_action :authenticate_user!, except: [:index, :show]
  require 'payjp'

  def index
    @products = Product.includes(:images).order('created_at DESC')
    @categorise = Product.where(category_id: 3).order('created_at DESC')
  end

  def new
    @products = Product.new
  end

  def create
    @product = Product.new(params.require(:product).permit(:id, :explanation, :name, :region, :size, :price, :shipping_days, :postage, :created_at, :updated_at).merge(user_id: "1", condition_id: "1", category_id: "1", bland_id: "1"))
    @product.save!
  end

  def show
    @product    = Product.find(params[:id])
    @user       = User.find(@product.user)
    @bland      = Bland.find(@product.bland)
    @category   = Category.where(product_id: @product.id)
    @condition  = Condition.find(@product.condition)
    @address    = Address.where(user_id: @product.user)
    @evaluation = Evaluation.where(user_id: @product.user)
    @images     = Image.where(product_id: @product.id)
  end

  def buy
    @product = Product.find(params[:id])
    @address = Address.where(user_id: current_user.id)[0]
    @image   = Image.where(product_id: @product.id)[0]
    @card    = Card.find(params[:id])
    card     = Card.where(user_id: current_user.id).first
    Payjp.api_key = "sk_test_cf98ef02cadd3ab814d4dc9e"
    customer = Payjp::Customer.retrieve(card.customer_id)
    @default_card_information = Payjp::Customer.retrieve(card.customer_id).cards.data[0]
  end

  def pay
    @card = Card.where(user_id: current_user.id)
    customer_card = ""
    @card.each do |c|
      customer_card = c
    end
    @product = Product.find(params[:id])
    @product.soldout = true
    @product.save!
    Payjp.api_key = "sk_test_cf98ef02cadd3ab814d4dc9e"
    @charge = Payjp::Charge.create(
    amount: @product.price,
    customer: customer_card.customer_id,
    currency: 'jpy'
    )
  end

  private

  def set_params
    
  end
end
