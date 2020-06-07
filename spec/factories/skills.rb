# == Schema Information
#
# Table name: skills
#
#  id         :bigint           not null, primary key
#  kind       :integer
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_skills_on_name  (name) UNIQUE
#
FactoryBot.define do
  factory :skill do
    name { "MyString" }
    kind { 1 }
  end
end
