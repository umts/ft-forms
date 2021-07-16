# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  let(:user) { create :user }

  describe 'full_name' do
    subject(:call) { user.full_name }

    it { is_expected.to eq "#{user.first_name} #{user.last_name}" }
  end

  describe 'proper_name' do
    subject(:call) { user.proper_name }

    it { is_expected.to eq "#{user.last_name}, #{user.first_name}" }
  end
end
