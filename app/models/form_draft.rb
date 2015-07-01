class FormDraft < ActiveRecord::Base
  belongs_to :form
  belongs_to :user
  has_many :fields, dependent: :destroy
  accepts_nested_attributes_for :fields
  validates :form, :name, presence: true
  # One user can only have one draft per form
  validates :form, uniqueness: { scope: :user_id }

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

  def update_form!
    form.update(attributes.except 'form_id', 'user_id')
    # Don't need to retain the fields, since the draft will be deleted.
    # Just switch them over to belonging to the form.
    form.fields.delete_all
    fields.update_all form_id: form.id, form_draft_id: nil
    destroy
  end

  private

  def new_field_number
    fields.count + 1
  end
end
