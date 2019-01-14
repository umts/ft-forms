# frozen_string_literal: true

class FormDraft < ApplicationRecord
  belongs_to :form, optional: true
  belongs_to :user
  has_many :fields, dependent: :destroy
  accepts_nested_attributes_for :fields
  validates :name, presence: true
  # One user can only have one draft per form
  validates :form, uniqueness: { scope: :user_id }, allow_nil: true

  def new_field
    Field.new form_draft: self, number: new_field_number
  end

  def update_form!
    form_attributes = attributes.except 'form_id', 'user_id', 'id'
    form = form || Form.new
    form.update form_attributes
    # Don't need to retain the fields, since the draft will be deleted.
    # Just switch them over to belonging to the form.
    form.fields.delete_all
    fields.update_all form_id: form.id, form_draft_id: nil
    delete
  end

  private

  def new_field_number
    fields.last.try(:number).try(:+, 1) || 1
  end
end
