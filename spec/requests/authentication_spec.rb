# frozen_string_literal: true

require 'rails_helper'

# Request specs don't include sessions data,
# equivalent to not being authenticated.
RSpec.describe 'Authentication' do
  context 'with an unauthenticated user' do
    it 'redirects to unauthenticated session path' do
      get '/forms'
      expect(response).to redirect_to unauthenticated_session_path
    end
  end
end
