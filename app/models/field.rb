class Field < ActiveRecord::Base
  belongs_to :form
  belongs_to :form_draft

  DATA_TYPES = %w(date date/time explanation heading long-text
                  number options text time yes/no)
  serialize :options, Array

  validate :belongs_to_form_or_form_draft?
  validates :data_type,
            inclusion: { in: DATA_TYPES }
  validates :number,
            :prompt,
            presence: true
  # Equivalent to
  # validates :form, uniqueness: { scope: :number, allow_blank: true }
  # but the point is that the number is unique respective to the form,
  # not the other way around
  validates :number, uniqueness: { scope: :form,
                                   if: -> { form.present? } }
  validates :number, uniqueness: { scope: :form_draft,
                                   if: -> { form_draft.present? } }
  validates :required,
            inclusion: { in: [true, false],
                         message: 'must be true or false' }

  default_scope { order :number }
  scope :not_new, -> { where.not id: nil }

  def date?
    data_type == 'date'
  end

  def explanation?
    data_type == 'explanation'
  end

  def heading?
    data_type == 'heading'
  end

  def takes_placeholder?
    %w(date date/time long-text text time).include? data_type
  end

  def unique_name
    "field_#{number}"
  end

  def unique_heading_name
    "header_#{number}"
  end

  def unique_prompt_name
    "prompt_#{number}"
  end

  private

  # must have form or form draft. cannot have both
  def belongs_to_form_or_form_draft?
    return if form.present? ^ form_draft.present?
    errors.add :base,
               'You must specify either a form or form_draft, but not both'
  end
end
