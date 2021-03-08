# frozen_string_literal: true

class FieldsController < ApplicationController
  before_action :find_field

  def update
    @field.update options: params.require(:options).split("\r\n")
    redirect_to edit_form_draft_path(@field.form_draft)
  end

  private

  def find_field
    @field = Field.find(params.require :id)

    redirect_back(fallback_location: forms_path) if @field.form_draft.blank?
  end
end
