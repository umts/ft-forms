# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'transit-it@admin.umass.edu'
  default reply_to: 'fieldtrip@umass.edu'
end
