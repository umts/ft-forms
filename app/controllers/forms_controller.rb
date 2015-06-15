class FormsController < ApplicationController
  def show
    @form = Form.find(params.require :id)
  end
end
