class ProductsController < ApplicationController
  before_action :set_params, only: :create
  before_action :set_product, only: [:show, :destroy, :buy, :pay, :create_like, :destroy_like, :create_comment]
  before_action :authenticate_user!, except: [:index, :show]
  require 'payjp'

  def index
    @products = Product.includes(:images).order('created_at DESC')
    @categorize = Product.where(category_id: 3).order('created_at DESC')
    @parents = Category.all.order("id ASC")
  end

  def new
    @product = Product.new
    @image = Image.new
  end

  def create
    @product = Product.new(set_params)
    unless @product.save!
      redirect_to new_product_path
    end
    for num in 1..10 do
      unless params[:product][:image][":image#{num}"].nil?
        @image = Image.new(image: params[:product][:image][":image#{num}"], product_id: @product.id)
        unless @image.save!
          redirect_to new_product_path
        end
      end
    end
  end

  def show
    @user       = User.find(@product.user)
    @bland      = Bland.find(@product.bland)
    @category   = Category.find(@product.category_id)
    @condition  = Condition.find(@product.condition)
    @address    = Address.where(user_id: @product.user)
    @evaluation = Evaluation.where(user_id: @product.user)
    @images     = Image.where(product_id: @product.id)
    @comment    = Comment.new
    @comments   = Comment.where(product_id: @product.id)
    @likenum    = 0
  end
  
  def destroy
    unless @product.destroy
      redirect_to product_path(@product)
    end
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

  def search
    return nil if params[:keyword] == ""
    @products = Product.where(["name LIKE ?", "%#{params[:keyword]}%"])
  end

  def create_like
    like = Like.new(user_id: current_user.id, product_id: @product.id)
    unless like.save!
      redirect_to product_path(@product)
    end
  end

  def destroy_like
    like = Like.find_by(user_id: current_user.id, product_id: @product.id)
    unless like.destroy!
      redirect_to product_path(@product)
    end
  end
  
  def create_comment
    @comment = Comment.new(comment: params[:comment], user_id: current_user.id, product_id: @product.id)
    unless @comment.save!
      redirect_to product_path(@product)
    end
  end
  
  private

  def set_product
    @product = Product.find(params[:id])
  end

  def set_params
    params.require(:product).permit(:explanation, :name, :region, :size, :price, :shipping_days, :postage, :bland_id, :condition_id, :category_id, images_attributes:[:image]).merge(user_id: current_user.id)
  end

end
