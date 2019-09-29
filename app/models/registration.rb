class Registration < ApplicationRecord
  STATUS = ["pending","confirmed","cancelled"]
  validates_inclusion_of :status, in: STATUS
  validates_presence_of :status, :ticket_id
  attr_accessor :current_step
  validates_presence_of :name,:email,:cellphone, if: :should_validate_basic_data?
  validates_presence_of :name,:email,:cellphone,:bio, if: :should_validate_all_data?
  validate :check_event_status,on: :create


  belongs_to :event
  belongs_to :ticket#,optional: true
  belongs_to :user, optional: true

  before_validation :generate_uuid, on: :create

  has_paper_trail

  scope :by_status, ->(s){where(status: s)}
  scope :by_ticket, ->(t){where(ticket_id: t)}

  def to_param
    self.uuid
  end

  protected

  def generate_uuid
    self.uuid = SecureRandom.uuid
  end

  def should_validate_basic_data?
    current_step == 2 #到第二步进行验证
  end

  def should_validate_all_data?
    current_step == 3 || status == "confirmed" #到第三步，或者最后状态是confirmed的时候进行验证
  end

  def check_event_status
    if self.event.status == "draft"
      errors.add(:base,"活动尚未开放报名")
    end
  end

end
