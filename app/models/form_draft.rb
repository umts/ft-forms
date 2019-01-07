# frozen_string_literal: true

class FormDraft < ApplicationRecord
  has_many :fields, dependent: :destroy
  belongs_to :form
  validates :form_id, uniqueness: true

  accepts_nested_attributes_for :fields

  def new_field
    Field.new form_draft: self, number: new_field_number
  end

  def update_fields(field_data)
    return if field_data.blank?
    field_data.each do |_index, field_attributes|
      next if field_attributes[:prompt].blank?
      field = fields.find_by number: field_attributes.fetch(:number)
      if field.present?
        field.update field_attributes
      else
        field_attributes[:form_draft_id] = id
        Field.create field_attributes
      end
    end
  end

  private

  def new_field_number
    fields.last.try(:number).try(:+, 1) || 1
  end


end
