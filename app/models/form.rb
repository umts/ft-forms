class Form < ActiveRecord::Base
  has_many :fields

  validates :name, presence: true, uniqueness: true

  default_scope { order :name }
end
