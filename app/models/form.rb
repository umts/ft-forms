class Form < ActiveRecord::Base
  has_many :fields
  accepts_nested_attributes_for :fields

  validates :name, presence: true, uniqueness: true

  default_scope { order :name }
end
