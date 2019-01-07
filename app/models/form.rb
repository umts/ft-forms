# frozen_string_literal: true

class Form < ApplicationRecord
  extend FriendlyId
  friendly_id :form_name, use: :slugged
  has_many :fields, dependent: :destroy
  has_one :draft, class_name: 'FormDraft',
                  foreign_key: :form_id,
                  dependent: :destroy
  accepts_nested_attributes_for :fields

  validates :name, presence: true, uniqueness: true
  default_scope { order :name }

  def new_field
    Field.new form: self, number: new_field_number
  end

  def form_name
    name.parameterize if name.present?
  end

  def create_draft
    return false if draft.present?
    draft_attributes = self.attributes.except('id', 'slug').merge form: self
    draft = FormDraft.create draft_attributes
    fields.each do |field|
      new_field = field.dup
      new_field.assign_attributes form_draft: draft, form: nil
      new_field.save
    end
    draft
  end

  private

  def new_field_number
    fields.last.try(:number).try(:+, 1) || 1
  end

end
