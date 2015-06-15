class Field < ActiveRecord::Base
  belongs_to :form

  DATA_TYPES = %w(text number yes/no date heading explanation)

  validates :data_type,
            inclusion: { in: DATA_TYPES }
  validates :form,
            :number,
            :prompt,
            presence: true
  validates :required,
            inclusion: { in: [true, false],
                         message: 'must be true or false' }
  validates :number, uniqueness: { scope: :form }

  default_scope { order :number }

  def date?
    data_type == 'date'
  end

  def explanation?
    data_type == 'explanation'
  end

  def heading?
    data_type == 'heading'
  end
end
