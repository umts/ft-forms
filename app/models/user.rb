class User < ActiveRecord::Base
  has_many :form_drafts

  validates :first_name,
            :last_name,
            :spire,
            presence: true
  validates :staff, inclusion: { in: [true, false],
                                 message: 'must be true or false' }
  validates :spire, uniqueness: true

  scope :staff,     -> { where staff: true }
  scope :not_staff, -> { where staff: false }

  def full_name
    "#{first_name} #{last_name}"
  end

  def proper_name
    "#{last_name}, #{first_name}"
  end
end
