require 'rails_helper'

describe FtFormsMailer do
  describe 'send_confirmation' do
    before :each do
      @to = 'test_to@example.com'
      @form_data = Hash['Email', @to]
    end
    let :output do
      FtFormsMailer.send_confirmation @form_data
    end
    it 'sends to the Email value in the form data' do
      expect(output.to).to eql Array(@to)
    end
    it 'has a subject of Meet & Greet Request Confirmation' do
      expect(output.subject).to eql 'Meet & Greet Request Confirmation'
    end
    it 'includes the form data in the email' do
      expect(output.body.encoded).to include 'Email', @to
    end
  end

  describe 'send_form' do
    before :each do
      @value = 'example value'
      @key = 'example key'
      @form_data = Hash[@key, @value]
    end
    let :output do
      FtFormsMailer.send_form @form_data
    end
    it 'sends to fieldtrip@umass.edu' do
      expect(output.to).to eql Array('fieldtrip@umass.edu')
    end
    it 'has a subject of New Meet & Greet Request' do
      expect(output.subject).to eql 'New Meet & Greet Request'
    end
    it 'includes the form data in the email' do
      expect(output.body.encoded).to include @key, @value
    end
  end
end
