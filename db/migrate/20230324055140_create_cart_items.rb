class CreateCartItems < ActiveRecord::Migration[6.0]
  def change
    create_table :cart_items do |t|
      t.integer :product_id
      t.integer :cart_id
      t.integer :quantity

      t.timestamps
    end
    add_index :cart_items, [:product_id, :cart_id]

  end
end
