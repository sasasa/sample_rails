# == Schema Information
#
# Table name: skills_users
#
#  id          :bigint           not null, primary key
#  proficiency :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  skill_id    :bigint           not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_skills_users_on_skill_id  (skill_id)
#  index_skills_users_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (skill_id => skills.id)
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :skills_user do
    skill { nil }
    user { nil }
    proficiency { 1 }
  end
end
