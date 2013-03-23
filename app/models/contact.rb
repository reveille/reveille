# == Schema Information
#
# Table name: contacts
#
#  id         :integer          not null, primary key
#  label      :string(255)
#  type       :string(255)
#  address    :string(255)
#  uuid       :string(255)      not null
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Contact < ActiveRecord::Base
  include Identifiable
  include ActiveModel::ForbiddenAttributesProtection

  belongs_to :user
  has_many :notification_rules

  validates :type, presence: true
  validates :label, presence: true
  validates :address, presence: true
end
