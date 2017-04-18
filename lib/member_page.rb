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

  field :first_name do
    noko.at_css('.field-name-field-first-name .field-item').text.tidy
  end

  field :last_name do
    noko.at_css('.field-name-field-last-name .field-item').text.tidy
  end

  field :other_names do
    noko.css('.field-name-field-other-names .field-item').map(&:text).map(&:tidy).join(';')
  end

  field :gender do
    noko.at_css('.field-name-field-gender .field-item').text.tidy
  end

  field :photo do
    img = noko.at_css('.field-name-field-picture .field-item img/@src') and img.text.tidy
  end
end
