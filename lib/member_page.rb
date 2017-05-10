# frozen_string_literal: true

require 'scraped'

class MemberPage < Scraped::HTML
  field :email do
    noko.css('.field-name-field-email .field-item a[@href*="parliament.gov.zm"]')
        .text
        .strip
  end

  field :birth_date do
    noko.css('.field-name-field-date .field-item .date-display-single/@content')
        .text
        .split('T')
        .first
  end
end
