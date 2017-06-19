# frozen_string_literal: true

require 'scraped'

class MembersPage < Scraped::HTML
  decorator Scraped::Response::Decorator::CleanUrls

  field :member_rows do
    noko.css('div.view-members-of-parliament div.panel-display').map do |row|
      fragment row => MemberRow
    end
  end

  field :next do
    noko.xpath('//a[contains(@title,"Go to next page")]/@href').text
  end
end
