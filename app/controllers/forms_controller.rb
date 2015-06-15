class FormsController < ApplicationController
  def meet_and_greet
    @form = Form.find_by name: 'Meet & Greet Request Form'
    render 'show'
  end

  def show
    @form = Form.find(params.require :id)
  end
end
