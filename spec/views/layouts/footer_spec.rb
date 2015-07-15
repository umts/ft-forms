require 'rails_helper'
include RSpecHtmlMatchers

describe 'layouts/_footer.haml' do
  # From the UMass Digital Brand Guide - "We live in a digital world."
  it 'has a span with a class of content'
  it 'includes the copyright year'
  it 'includes a link to umass.edu'
  it 'links to the correct Site Policies URL'
  it 'has us as the Site Contact Email'
  it 'is bullet-separated'
end
