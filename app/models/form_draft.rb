# frozen_string_literal: true

class FormDraft < ApplicationRecord
  belongs_to :form, optional: true, inverse_of: :drafts
  belongs_to :user
  has_many :fields, dependent: :destroy
  accepts_nested_attributes_for :fields
  validates :name, presence: true
  # One user can only have one draft per form
  validates :form, uniqueness: { scope: :user_id }, allow_nil: true

  def new_field
    Field.new form_draft: self, number: new_field_number
  end

  # to skip the belongs_to_form_or_form_draft validation so we can update the
  # fields
  # rubocop:disable Rails/SkipsModelValidations
  def update_form!
    form_attributes = attributes.except 'form_id', 'user_id', 'id'
    form = self.form || Form.new
    form.update form_attributes
    # Don't need to retain the fields, since the draft will be deleted.
    # Just switch them over to belonging to the form.
    form.fields.delete_all
    fields.update_all form_draft_id: nil, form_id: form.id
    delete
  end
  # rubocop:enable Rails/SkipsModelValidations

  private

  def new_field_number
    fields.last.try(:number).try(:+, 1) || 1
  end
end
