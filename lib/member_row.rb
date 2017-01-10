# frozen_string_literal: true
require 'scraped'

class MemberRow < Scraped::HTML
  field :id do
    member_url.split('/').last
  end

  field :name do
    noko.css('.views-field-view-node a').text.split(/\s+/).join(' ').strip.gsub(/\s*,\s*MP\s*$/, '')
  end

  field :photo do
    noko.css('div.field-content img/@src').text
  end

  field :constituency do
    noko.css('span.views-field-field-constituency-name .field-content').text.strip
  end

  field :party do
    party_name_and_id.first
  end

  field :party_id do
    party_name_and_id.last
  end

  field :member_url do
    URI.join(BASE, noko.css('.views-field-view-node a/@href').text).to_s
  end

  private

  def party_name_and_id
    noko.css('span.views-field-field-political-party .field-content').text.strip
        .match(/(.*) \((.*)\)/).captures
  end
end
