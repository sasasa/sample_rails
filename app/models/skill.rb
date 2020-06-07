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
class Skill < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :kind, presence: true

  has_many :skillsUsers
  has_many :users, through: :skillsUsers
  KIND_NAMES = {1=> "オフィス", 2=> "デザイン", 3=> "プログラミング",}
  def kind_name
    KIND_NAMES[kind]
  end

  def self.skillhash_by_kind_name
    all.inject({}) do |result, skill|
      result[skill.kind_name] = [] unless result[skill.kind_name]
      result[skill.kind_name] << skill
      result
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[name]
  end
end
