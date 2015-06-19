class FormsController < ApplicationController
  
  def edit
    @form = Form.find(params.require :id)
  end
  
  def meet_and_greet
    @form = Form.find_by name: 'Meet & Greet Request Form'
    render 'show'
  end

  def preview
    @form = Form.find(params.require :id)
    params.require(:form).permit!
    @form.assign_attributes params[:form]
    @preview = true
    render 'show'
  end

  def show
    @form = Form.find(params.require :id)
  end

  # We're implementing this later, disable warnings.
  # rubocop:disable Style/EmptyElse
  # rubocop:disable Style/GuardClause
  def submit
    @form = Form.find(params.require :id)
    responses = params.require :responses
    if FtFormsMailer.send_form responses
      FtFormsMailer.send_confirmation responses
      redirect_to thank_you_form_url
    else
      # TODO
    end
  end
  # rubocop:enable Style/EmptyElse
  # rubocop:enable Style/GuardClause

  def thank_you
    @form = Form.find(params.require :id)
  end
end
