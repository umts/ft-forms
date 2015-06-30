class FormDraft < ActiveRecord::Base
  belongs_to :form
  belongs_to :user
  has_many :fields
  accepts_nested_attributes_for :fields
  validates :name, presence: true
  # One user can only have one draft per form
  validates :form, uniqueness: { scope: :user }

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

  private

  def new_field_number
    fields.count + 1
  end
end
