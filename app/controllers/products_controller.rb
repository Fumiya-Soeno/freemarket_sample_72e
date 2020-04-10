class ProductsController < ApplicationController
  before_action :set_params, only: [:create, :edit, :update]
  before_action :set_product, only: [:show, :buy, :destroy, :pay]
  before_action :authenticate_user!, except: [:index, :show]
  require 'payjp'

  def index
    @products = Product.includes(:images).order('created_at DESC')
    @categorise = Product.where(category_id: 1).order('created_at DESC')
  end

  def new
    @products = Product.new
  end

  def create
    @product = Product.new(set_params)
    unless @product.save!
      redirect_to new_product_path
    end
  end

  def show
    @user       = User.find(@product.user)
    @bland      = Bland.find(@product.bland)
    @category   = Category.where(product_id: @product.id)
    @condition  = Condition.find(@product.condition)
    @address    = Address.where(user_id: @product.user)
    @evaluation = Evaluation.where(user_id: @product.user)
    @images     = Image.where(product_id: @product.id)
  end

  def edit
    @product    = Product.find(params[:id])
    # @image    = Image.find(params[:id])
  end

  def update
    product = Product.find(params[:id])
    product.update
    
  end


  def buy
    @address = Address.where(user_id: current_user.id)[0]
    @image   = Image.where(product_id: @product.id)[0]
    @card_ex = Card.where(user_id: current_user.id)
    if @card_ex.exists?
      card     = Card.where(user_id: current_user.id).first
      @card    = Card.find(params[:id])
      Payjp.api_key = ENV['PAYJP_PRIVATE_KEY']
      customer = Payjp::Customer.retrieve(card.customer_id)
      @default_card_information = Payjp::Customer.retrieve(card.customer_id).cards.data[0]
    end
  end

  def pay
    @card = Card.where(user_id: current_user.id)
    customer_card = ""
    @card.each do |c|
      customer_card = c
    end
    @product.soldout = true
    @product.save!
    Payjp.api_key = ENV['PAYJP_PRIVATE_KEY']
    @charge = Payjp::Charge.create(
    amount: @product.price,
    customer: customer_card.customer_id,
    currency: 'jpy'
    )
  end

  def destroy
    unless @product.destroy
      redirect_to product_path(@product)
    end
  end
  
  def search
    return nil if params[:keyword] == ""
    @products = Product.where(["name LIKE ?", "%#{params[:keyword]}%"])
    respond_to do |format|
      format.html
      format.json
    end
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def set_params
    # ダミーです、商品出品と編集に使用します
    params.require(:product).permit(:id, :explanation, :name, :region, :size, :price, :shipping_days, :postage, :created_at, :updated_at).merge(user_id: "1", condition_id: "1", category_id: "1", bland_id: "1")
  end
end
