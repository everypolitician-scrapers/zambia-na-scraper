# frozen_string_literal: true
require 'scraped_page'

class MemberPage < ScrapedPage
  field :id do
    url.to_s.split('/').last
  end

  field :email do
    noko
      .css('.field-name-field-email .field-item a[@href*="parliament.gov.zm"]')
      .text
      .strip
  end

  field :birth_date do
    noko
      .css('.field-name-field-date .field-item .date-display-single/@content')
      .text
      .split('T')
      .first
  end

  field :term do
    2016
  end
end
