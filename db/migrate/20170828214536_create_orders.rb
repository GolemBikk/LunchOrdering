class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.datetime :order_date,     null: false
      t.integer :first_course_id, null: false
      t.integer :main_course_id,  null: false
      t.integer :drink_id,        null: false

      t.timestamps
    end

    add_reference :orders, :user, index: true
    add_index :orders, :first_course_id
    add_index :orders, :main_course_id
    add_index :orders, :drink_id
  end
end
