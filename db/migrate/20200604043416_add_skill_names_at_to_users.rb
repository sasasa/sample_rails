class AddSkillNamesAtToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :skill_names, :string
    add_index :users, :skill_names
  end
end
