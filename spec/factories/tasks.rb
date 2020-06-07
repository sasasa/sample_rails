# == Schema Information
#
# Table name: tasks
#
#  id          :bigint           not null, primary key
#  description :text
#  name        :string(30)       not null
#  special     :boolean          default(FALSE), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_tasks_on_name     (name)
#  index_tasks_on_user_id  (user_id)
#
FactoryBot.define do
  factory :task do
    name { 'テストを書く' }
    description { 'RSpec＆Capybara＆FactoryBotを準備する' }
    user
    # association :user, factory: :admin_user
  end
end
