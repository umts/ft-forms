class FormsController < ApplicationController
  before_action :find_form, except: [:index, :meet_and_greet, :submit]
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
    @form_changes = params.require(:form).permit!
    # form_changes = params.require(:form).permit :name
    @form.assign_attributes @form_changes
    @preview = true
    render 'show'
  end

  def show
    @submit = true unless params[:no_submit]
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
  end

  # We're implementing this later, disable warnings.
  # rubocop:disable Style/EmptyElse
  # rubocop:disable Style/GuardClause
  def update
    @form_changes = params.require(:form).permit!
    # form_changes = params.require(:form).permit :name
    if @form.update @form_changes
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
