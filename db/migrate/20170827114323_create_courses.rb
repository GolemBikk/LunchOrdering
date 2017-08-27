class CreateCourses < ActiveRecord::Migration[5.0]
  def change
    create_table :courses do |t|
      t.string  :title,       null: false, default: ""
      t.string  :course_type, null: false, default: ""
      t.integer :price,       null: false, default: 0

      t.timestamps
    end

    add_index :courses, :title
  end
end
