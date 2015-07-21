require 'rails_helper'
include RSpecHtmlMatchers

describe 'ft_forms_mailer/send_confirmation_text_spec.rb' do
  before :each do
    @form = create :form
    @field = create :field, prompt: 'thing', form: @form
   # response? how do. 
  end
  it 'includes the form data of the request' do
    render
    expect(rendered).to include 'thing'
  end
end
