class Form < ActiveRecord::Base
  has_many :fields
  has_many :form_drafts
  accepts_nested_attributes_for :fields

  validates :name, presence: true, uniqueness: true

  default_scope { order :name }

  def create_draft(user)
    draft = FormDraft.new attributes.merge(user: user, form: self)
    draft.fields = fields
    draft.save
    draft
  end
end
