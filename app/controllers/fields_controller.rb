# frozen_string_literal: true

class FieldsController < ApplicationController
  before_action :find_field

  def update
    @field.update options: params.require(:options).split("\r\n")
    #TODO: redirect somewhere?
  end

  private

  # '...and return' is correct here, disable rubocop warning
  # rubocop:disable Style/AndOr
  def find_field
    @field = Field.find(params.require :id)
    redirect_back(fallback_location: forms_path) #TODO and return if
  end
  # rubocop:enable Style/AndOr
end
