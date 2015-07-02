class FieldsController < ApplicationController
  before_action :find_field

  def edit
    redirect_to :back and return unless @field.form_draft.present?
  end

  def update
    @field.update! options: params.require(:options).split("\r\n")
    redirect_to edit_form_draft_path(@field.form_draft)
  end

  private

  def find_field
    @field = Field.find(params.require :id)
  end
end
