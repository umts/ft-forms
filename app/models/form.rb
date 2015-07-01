class Form < ActiveRecord::Base
  has_many :fields
  has_many :drafts, class_name: FormDraft, foreign_key: :form_id
  accepts_nested_attributes_for :fields

  validates :name, presence: true, uniqueness: true

  default_scope { order :name }

  def create_draft(user)
    return false if draft_belonging_to(user).present?
    draft = FormDraft.new attributes.merge(user: user, form: self)
    draft.save
    fields.each do |field|
      new_field = field.dup
      new_field.assign_attributes form: nil, form_draft: draft
      new_field.save!
    end
    draft
  end

  def draft_belonging_to(user)
    drafts.find_by user_id: user.id
  end

  def draft_belonging_to?(user)
    draft_belonging_to(user).present?
  end
end
