class FormDraft < ActiveRecord::Base
  belongs_to :form
  belongs_to :user
  has_many :fields, dependent: :destroy
  accepts_nested_attributes_for :fields
  validates :form, :name, presence: true
  # One user can only have one draft per form
  validates :form, uniqueness: { scope: :user_id }

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
    Field.new form_draft: self, number: new_field_number
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
      field = fields.find_by number: field_attributes.fetch(:number)
      if field.present?
        field.update field_attributes
      else
        field_attributes.merge! form_draft_id: id
        Field.create field_attributes
      end
    end
  end

  def update_form!
    form.update(attributes.except 'form_id', 'user_id', 'id')
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
