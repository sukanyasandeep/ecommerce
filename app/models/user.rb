class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :orders
  has_many :products, through: :orders

  # has_many :carts
  # has_many :products, through: :carts

  has_one :cart

  def add_to_cart(product_id)
    #Cart.create(user_id: self.id)
    self.create_cart if self.try(:cart).blank?
    puts "eeeeeeeeeeee....."+self.cart.inspect
    if self.cart.cart_items.where(user_id: self.id, product_id: product_id).blank?
      puts "aaaaaaaaaaaaaaaaaa...."
      self.cart.cart_items.create(user_id: self.id, product_id: product_id, quantity: 1)
    else
      puts "bbbbbbbbbbbbbbb......."
      self.cart.cart_items.where(user_id: self.id, product_id: product_id).update(quantity: (self.cart.cart_items.where(user_id: self.id, product_id: product_id).first.quantity.to_i + 1))
    end
  end

  def remove_from_cart(product_id)
    self.cart.cart_items.where(user_id: self.id, product_id: product_id).destroy_all unless self.cart.cart_items.where(user_id: self.id, product_id: product_id).blank?
  end

  def remove_one_from_cart(product_id)
    unless self.cart.cart_items.where(user_id: self.id, product_id: product_id).blank?      
      self.cart.cart_items.where(user_id: self.id, product_id: product_id).update(quantity: (self.cart.cart_items.where(user_id: self.id, product_id: product_id).first.quantity.to_i - 1))
    end
  end

  def cart_count
    puts "LLLLLLLLLLLLLLLl..."+self.cart.inspect
    cartitems = self.try(:cart).try(:cart_items)
    puts "kkkkkkkkkkkkkk...."+cartitems.inspect
    cartitems = cartitems.map { |cart_item| cart_item.quantity.to_i }.sum unless cartitems.blank?
  end

  def cart_total_price
    get_cart_products_with_qty.blank? ? 0 : get_cart_products_with_qty.map { |product, qty| product.price * qty.to_i }.reduce(:+) 
  end

  def get_cart_products_with_qty
     carts = self.try(:cart).try(:cart_items)
     unless carts.blank?
       get_cart_products_with_qty = carts.map { |cart| [cart.product, cart.quantity]}
       get_cart_products_with_qty
     end
  end

end
