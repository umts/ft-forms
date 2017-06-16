# frozen_string_literal: true

class Form < ApplicationRecord
  extend FriendlyId
  friendly_id :form_name, use: :slugged
  has_many :fields, dependent: :destroy
  accepts_nested_attributes_for :fields
  has_drafts

  validates :name, presence: true, uniqueness: true
  default_scope { order :name }

  def move_field(field_number, direction)
    transaction do
      field = fields.find_by number: field_number
      other_number = case direction
                       when :up   then field_number - 1
                       when :down then field_number + 1
                     end
      other_field = fields.find_by number: other_number
      return unless other_field
      # Move the specified field without validation, since before we move
      # the other field out of its place, it will be invalid.
      field.number = other_number
      field.save validate: false
      other_field.update number: field_number
      # Validate it afterwards, and do nothing if there is an error.
      raise ActiveRecord::Rollback unless field.valid?
    end
  end

  def new_field
    Field.new form: self, number: new_field_number
  end

  def remove_field(field_number)
    field_to_remove = fields.find_by number: field_number
    field_to_remove.delete
    fields.where('number > ?', field_number).find_each do |field|
      field.number -= 1
      field.save
    end
    save
    field_to_remove
  end

  def update_fields(field_data)
    return if field_data.blank?
    field_data.each do |_index, field_attributes|
      binding.pry
      next if field_attributes[:prompt].blank?
      field = fields.find_by number: field_attributes.fetch(:number)
      if field.present?
        field.update field_attributes
      else
        field_attributes[:form_id] = id
        Field.create field_attributes
      end
    end
  end

  def form_name
    name.parameterize
  end

  private

  def new_field_number
    fields.last.try(:number).try(:+, 1) || 1
  end

end
