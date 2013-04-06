# == Schema Information
#
# Table name: services
#
#  id                   :integer          not null, primary key
#  name                 :string(255)
#  auto_resolve_timeout :integer
#  acknowledge_timeout  :integer
#  state                :string(255)
#  uuid                 :string(255)
#  authentication_token :string(255)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class Service < ActiveRecord::Base
  include Identifiable
  
  hound_user

  devise :token_authenticatable

  belongs_to :account
  has_many :incidents, dependent: :destroy
  
  # scope :triggered_incidents, includes(:incidents).where('incidents.state = ?', 'triggered')
  # scope :acknowledged_incidents, includes(:incidents).where('incidents.state = ?', 'acknowledged')
  # scope :resolved_incidents, includes(:incidents).where('incidents.state = ?', 'resolved')

  has_many :alerts, through: :incidents
  has_one :service_escalation_policy
  has_one :escalation_policy, through: :service_escalation_policy

  validates :name, :acknowledge_timeout, :auto_resolve_timeout, :state,
    presence: true
  validates :name, uniqueness: true
  
  before_save :ensure_authentication_token

  state_machine initial: :enabled do
    state :enabled
    state :disabled

    event :enable do
      transition all => :enabled
    end

    event :disable do
      transition all => :disabled
    end
  end
end
