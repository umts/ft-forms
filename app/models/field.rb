class Field < ActiveRecord::Base
  belongs_to :form

  DATA_TYPES = %w(date date/time explanation heading
                  number options text time yes/no)
  serialize :options, Array

  validates :data_type,
            inclusion: { in: DATA_TYPES }
  validates :form,
            :number,
            :prompt,
            presence: true
  validates :number, uniqueness: { scope: :form }
  validates :options,
            presence: true,
            if: -> { data_type == 'options' }
  validates :required,
            inclusion: { in: [true, false],
                         message: 'must be true or false' }

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
