# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
user = User.create(name: 'saeki', email: 'masaakisaeki@gmail.com', password: 'hogehoge', password_confirmation: 'hogehoge', admin: true)


# kind 
# office 0 design 1 programing 2
s1 = Skill.create!(name: 'ワード', kind: "1")
Skill.create!(name: 'エクセル', kind: "1")
Skill.create!(name: 'パワポ', kind: "1")
Skill.create!(name: 'XD', kind: "2")
s2 = Skill.create!(name: 'フォトショップ', kind: "2")
Skill.create!(name: 'イラストレーター', kind: "2")
s3 = Skill.create!(name: 'Ruby', kind: "3")
Skill.create!(name: 'PHP', kind: "3")
Skill.create!(name: 'Python', kind: "3")
Skill.create!(name: 'Java', kind: "3")

user.update_skill_names!([s1, s2, s3])

(1..100).each do |i|
  u = User.create(name: "user_#{i}", email: "user_#{i}@gmail.com", password: 'hogehoge', password_confirmation: 'hogehoge', admin: [true,false].sample)
  
  u.update_skill_names!(Skill.all.sample(2).map(&:id))
end