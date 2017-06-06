# frozen_string_literal: true

class FieldsController < ApplicationController
  before_action :find_field

  def update
    @field.update options: params.require(:options).split("\r\n")
    redirect_to edit_form_draft_path(@field.form_draft)
  end

  private

  # '...and return' is correct here, disable rubocop warning
  # rubocop:disable Style/AndOr
  def find_field
    @field = Field.find(params.require :id)
    redirect_to request.referer and return if @field.form_draft.blank?
  end
  # rubocop:enable Style/AndOr
end
