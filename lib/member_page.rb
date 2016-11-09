# frozen_string_literal: true
require 'scraped_page'

class MemberPage < ScrapedPage
  def initialize(url:, strategy: Strategy::LiveRequest.new, entry:)
    @entry = entry
    super(url: url, strategy: strategy)
  end

  field :id do
    url.to_s.split('/').last
  end

  field :name do
    entry
      .css('.views-field-view-node a')
      .text
      .split(/\s+/)
      .join(' ')
      .strip
      .gsub(/\s*,\s*MP\s*$/, '')
  end

  field :photo do
    entry.css('div.field-content img/@src').text
  end

  field :constituency do
    entry
      .css('span.views-field-field-constituency-name .field-content')
      .text
      .strip
  end

  field :party do
    split_party.first
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

  field :party_id do
    split_party.last
  end

  private

  attr_reader :entry

  def split_party
    @split_party ||= entry
                     .css('.views-field-field-political-party .field-content')
                     .text
                     .strip
                     .match(/(.*) \((.*)\)/)
                     .captures
  end
end
