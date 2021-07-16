# frozen_string_literal: true

class Form < ApplicationRecord
  extend FriendlyId
  friendly_id :form_name, use: :slugged
  has_many :fields, dependent: :destroy
  has_many :drafts, class_name: 'FormDraft',
                    dependent: :destroy,
                    inverse_of: :form
  accepts_nested_attributes_for :fields

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  default_scope { order :name }

  def find_or_create_draft(user)
    return draft_belonging_to(user) if draft_belonging_to?(user)

    transaction do
      draft = create_draft_for user
      copy_fields_to draft
      draft
    end
  end

  def draft_belonging_to(user)
    drafts.find_by user_id: user.id
  end

  def draft_belonging_to?(user)
    draft_belonging_to(user).present?
  end

  def form_name
    name.try(:parameterize)
  end

  private

  def create_draft_for(user)
    FormDraft.create dup.attributes
                        .symbolize_keys.except(:slug)
                        .merge(user: user, form: self)
  end

  def copy_fields_to(draft)
    fields.each do |field|
      new_field = field.dup
      new_field.assign_attributes form: nil, form_draft: draft
      new_field.save
    end
  end
end
