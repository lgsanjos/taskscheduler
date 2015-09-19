class CreateTaskExecutions < ActiveRecord::Migration
  def change
    create_table :task_executions do |t|
      t.references :task
      t.datetime :start
      t.datetime :end
      t.string :status

      t.timestamps null: false
    end
  end
end
