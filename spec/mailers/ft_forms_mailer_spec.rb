# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FtFormsMailer do
  let(:user) { create :user }
  let :form_data do
    { 'field_2' => 'A response',
      'prompt_2' => 'A Prompt' }
  end

  describe 'send_confirmation' do
    subject :output do
      described_class.send_confirmation user, form_data, reply_to
    end

    let(:reply_to) { 'fieldtrip@umass.edu' }

    it 'sends to the email of the user' do
      expect(output.to).to eq Array(user.email)
    end

    it 'has a reply-to' do
      expect(output.reply_to).to eq Array(reply_to)
    end

    it 'has a subject of "Meet & Greet Request Confirmation"' do
      expect(output.subject).to eq 'Meet & Greet Request Confirmation'
    end

    it 'includes the form data in the email' do
      expect(output.body.encoded).to include('A Prompt: A response')
    end
  end

  describe 'send_form' do
    subject :output do
      described_class.send_form form, form_data, user
    end

    let(:form) { create :form }

    it 'sends to the email of the form' do
      expect(output.to).to eq Array(form.email)
    end

    it 'sends to multiple emails of the form if separated by comma' do
      email1 = 'person@test.host'
      email2 = 'people@test.host'
      form.update email: [email1, email2].join(', ')
      expect(output.to).to eq [email1, email2]
    end

    it 'has a subject of "New Meet & Greet Request"' do
      expect(output.subject).to eql 'New Meet & Greet Request'
    end

    it 'includes the form data in the email' do
      expect(output.body.encoded).to include('A Prompt: A response')
    end
  end
end
