class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.string :path
      t.datetime :start
      t.datetime :end
      t.string :days
      t.string :key

      t.timestamps null: false
    end
  end
end
