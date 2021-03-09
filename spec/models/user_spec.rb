# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  describe 'full_name' do
    before :each do
      @user = create :user
    end
    it 'gives first name followed by last name' do
      expect(@user.full_name).to eql "#{@user.first_name} #{@user.last_name}"
    end
  end

  describe 'proper_name' do
    before :each do
      @user = create :user
    end
    it 'gives last name, first name' do
      expect(@user.proper_name).to eql "#{@user.last_name}, #{@user.first_name}"
    end
  end
end
