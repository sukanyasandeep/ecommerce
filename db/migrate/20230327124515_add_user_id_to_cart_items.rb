class AddUserIdToCartItems < ActiveRecord::Migration[6.0]
  def change
    add_column :cart_items, :user_id, :integer
  end
end
