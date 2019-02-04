# frozen_string_literal: true

require 'rails_helper'

describe 'interacting with forms/drafts from the index', js: true do
  before :each do
  end
  context 'not staff' do
    it 'does not allow access' do
      login_as(create :user, :not_staff)
      visit '/forms'
      warning = 'You do not have permission to access this page'
      expect(page).to have_css 'h1', text: warning
    end
  end
  context 'staff' do
    before :each do
      user = create :user, :staff
      @form = create :form, name: 'Animal Planet'
      @draft = create :form_draft, name: 'Favorite Colors', user: user
      login_as(user)
      visit '/forms'
    end
    it 'destroys drafts when the appropriate button is clicked' do
      expect(page).to have_text 'Favorite Colors'
      find("a[href='#{form_draft_path(@draft)}']").click
      page.driver.browser.switch_to.alert.accept
      expect(page).not_to have_text 'Favorite Colors'
      expect(FormDraft.count).to eql 0
      within('#flash') do
        expect(page).to have_text 'Draft has been discarded'
      end
    end
  end
end
