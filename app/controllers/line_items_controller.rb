class LineItemsController < ApplicationController
  before_action :set_line_item, only: [:show, :update, :destroy]

  # GET /line_items
  def index
    @line_items = LineItem.all

    render json: @line_items
  end

  # GET /line_items/1
  def show
    render json: @line_item
  end

  # POST /line_items
  def create
    cart = Cart.find(params[:cart_id])
    product = Product.find(params[:product_id])
    @line_item = LineItem.find_by(cart_id: params[:cart_id], product_id: params[:product_id])
    if @line_item
      @line_item.quantity = 1 unless @line_item.quantity?
      @line_item.quantity += 1
    else
      @line_item = cart.line_items.build(product: product)
    end

    if @line_item.save
      render json: @line_item, status: :created, location: @line_item
    else
      render json: @line_item.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /line_items/1
  def update
    if @line_item.update(line_item_params)
      render json: @line_item
    else
      render json: @line_item.errors, status: :unprocessable_entity
    end
  end

  # DELETE /line_items/1
  def destroy
    @line_item.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_line_item
      @line_item = LineItem.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def line_item_params
      params.require(:line_item).permit(:product_id, :cart_id)
    end
end
