class Form < ActiveRecord::Base
  has_many :fields

  validates :name, presence: true, uniqueness: true
end
