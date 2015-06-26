class Form < ActiveRecord::Base
  has_many :fields
  accepts_nested_attributes_for :fields

  validates :name, presence: true, uniqueness: true

  default_scope { order :name }

  def new_field
    Field.new form_id: id, number: new_field_number
  end

  private do
    def new_field_number
      fields.count + 1
    end
  end
end
