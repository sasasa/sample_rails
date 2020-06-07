class AddSpecialToTasks < ActiveRecord::Migration[6.0]
  def change
    add_column :tasks, :special, :boolean, default: false, null: false
  end
end
