class FormsController < ApplicationController
  before_action :find_form, except: [:index, :meet_and_greet]

  def edit
  end

  def index
    @forms = Form.all
  end

  def meet_and_greet
    @form = Form.find_by name: 'Meet & Greet Request Form'
    render 'show'
  end

  def preview
    @changes = params.require(:form).permit!
    @form.assign_attributes @changes
  end

  def show
  end

  # We're implementing this later, disable warnings.
  # rubocop:disable Style/EmptyElse
  # rubocop:disable Style/GuardClause
  def submit
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

  # We're implementing this later, disable warnings.
  # rubocop:disable Style/EmptyElse
  # rubocop:disable Style/GuardClause
  def update
    # TODO: something better than this
    params.require(:form).permit!
    if @form.update params[:form]
      flash[:message] = 'Form has been updated.'
      redirect_to forms_url
    else # TODO
    end
  end
  # rubocop:enable Style/EmptyElse
  # rubocop:enable Style/GuardClause

  private

  def find_form
    @form = Form.find(params.require :id)
  end
end
