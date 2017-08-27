class CreateWeekdayMenus < ActiveRecord::Migration[5.0]
  def change
    create_table :weekday_menus do |t|
      t.string :weekday, null: false, default: ""

      t.timestamps
    end

    add_reference :weekday_menus, :course, index: true
  end
end
