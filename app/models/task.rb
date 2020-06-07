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
class Task < ApplicationRecord
  validates :name, presence: true
  validates :name, length: { maximum: 30 }
  validates :name, uniqueness: true, uniqueness: { scope: :user_id }
  validate :validate_name_not_including_comma

  belongs_to :user

  scope :recent, ->{ order(created_at: :desc) }
  has_one_attached :image

  def self.ransackable_attributes(auth_object = nil)
    %w[name created_at]
  end
  
  def self.ransackable_associations(auth_object = nil)
    %w[user]
  end

  def self.csv_attributes
    ["name", "description", "created_at", "updated_at"]
  end

  def self.generate_csv
    CSV.generate(headers: true) do |csv|
      csv << csv_attributes
      all.each do |task|
        csv << csv_attributes.map{|attr| task.send(attr) }
      end
    end
  end

  def self.import(file)
    if file
      CSV.foreach(file.path, headers: true) do |row|
        task = new
        task.attributes = row.to_hash.slice(*csv_attributes)
        task.save!
      end
      true
    else
      false
    end
  end

  private
  def validate_name_not_including_comma
    errors.add(:name, 'にカンマを含めることはできません') if name&.include?(',')
  end
end
