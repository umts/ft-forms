class Field < ActiveRecord::Base
  belongs_to :form

  DATA_TYPES = %w(text number yes/no date heading explanation)

  validates :data_type,
            inclusion: { in: DATA_TYPES }
  validates :form,
            :number,
            presence: true
  validates :prompt,
            presence: true,
            unless: -> { %w(heading explanation).include? data_type }
  validates :required,
            inclusion: { in: [true, false],
                         message: 'must be true or false' }
  validates :number, uniqueness: { scope: :form }

  default_scope { order :number }
end
