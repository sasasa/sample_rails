# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  admin           :boolean          default(FALSE), not null
#  customer        :string
#  deleted_at      :datetime
#  email           :string           not null
#  locale          :string           default("ja"), not null
#  name            :string           not null
#  password_digest :string           not null
#  premium         :boolean          default(FALSE), not null
#  skill_names     :string
#  subscription    :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_deleted_at   (deleted_at)
#  index_users_on_email        (email) UNIQUE
#  index_users_on_skill_names  (skill_names)
#
FactoryBot.define do
  factory :user do
    name { 'テストユーザー' }
    email { 'test1@example.com' }
    password { 'password' }
  end
end
