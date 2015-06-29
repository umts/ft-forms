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

  private

  def new_field_number
    fields.count + 1
  end
end
