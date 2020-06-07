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
class User < ApplicationRecord
  attr_accessor:plan

  has_secure_password
  # acts_as_paranoid
  
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  has_many :tasks, dependent: :destroy
  has_many :skillsUsers, dependent: :destroy
  has_many :skills, through: :skillsUsers

  PLANS = {"1"=>"月次", "2"=>"年次"}
  PLANS_REMOTE = {"1"=>'pln_6c04034830aa5ad616c5447b1936', "2"=>'pln_3016b66e77175593f980c57b7f90'}

  def update_skill_names!(skill_ids_ary)
    skill_ids_ary.map!(&:id) if skill_ids_ary.first.is_a?(Skill) 

    ActiveRecord::Base.transaction do
      self.skill_ids = skill_ids_ary
      self.skill_names = skills.map(&:name).sort_by{|v|v}.join(',')
      save!
    end
  end

  def set_proficiency!(hash)
    ActiveRecord::Base.transaction do
      hash.each do |id, proficiency|
        skillsUser = self.skillsUsers.find(id)
        skillsUser.proficiency = proficiency
        skillsUser.save!
      end
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[id name email skill_names]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[skills]
  end
end
