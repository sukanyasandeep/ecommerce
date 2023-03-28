class OrderController < ApplicationController

  skip_before_action :verify_authenticity_token

  #Place order
  def create
    user_orders = {}
    @cart_products_with_qty = current_user.get_cart_products_with_qty
    @cart_total = current_user.cart_total_price
    user_orders[current_user] = [@cart_products_with_qty, @cart_total]
    user_orders.each do |user, value|
      value[0].each do |product, qty|
        if Order.find_by_user_id_and_product_id(current_user.id, product.id).blank?
          current_user.orders.create(user: current_user, product: product, quantity: qty)
        end 
      end
    end
    current_user.cart.destroy
  end

  def show
    orders = current_user.orders
    @cart_products_with_qty = orders.map { |order| [order.product, order.quantity]}
    @cart_total = @cart_products_with_qty.map { |product, qty| product.price * qty.to_i }.reduce(:+)
  end

end
