class CreateSkills < ActiveRecord::Migration[6.0]
  def change
    create_table :skills do |t|
      t.string :name
      t.integer :kind

      t.timestamps

      t.index [ :name ], unique: true
    end
  end
end
