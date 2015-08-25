require 'rails_helper'

describe FtFormsMailer do
  describe 'send_confirmation' do
    before :each do
      @user = create :user
      @response = 'A response'
      @prompt = 'A prompt'
      @form_data = {
        'field_2'  => @response,
        'prompt_2' => @prompt
      }
    end
    let :output do
      FtFormsMailer.send_confirmation @user, @form_data
    end
    it 'sends to the email of the user' do
      expect(output.to).to eql Array(@user.email)
    end
    it 'has a subject of Meet & Greet Request Confirmation' do
      expect(output.subject).to eql 'Meet & Greet Request Confirmation'
    end
    it 'includes the form data in the email' do
      expect(output.body.encoded).to include [@prompt, @response].join(': ')
    end
  end

  describe 'send_form' do
    before :each do
      @form = create :form
      @response = 'A response'
      @prompt = 'A prompt'
      @form_data = {
        'field_2'  => @response,
        'prompt_2' => @prompt
      }
    end
    let :output do
      FtFormsMailer.send_form @form, @form_data
    end
    it 'sends to the email of the form' do
      expect(output.to).to eql Array(@form.email)
    end
    it 'sends to multiple emails of the form if separated by comma' do
      email_1 = 'person@test.host'
      email_2 = 'people@test.host'
      @form.update email: [email_1, email_2].join(', ')
      expect(output.to).to eql [email_1, email_2]
    end
    it 'has a subject of New Meet & Greet Request' do
      expect(output.subject).to eql 'New Meet & Greet Request'
    end
    it 'includes the form data in the email' do
      expect(output.body.encoded).to include [@prompt, @response].join(': ')
    end
  end
end
