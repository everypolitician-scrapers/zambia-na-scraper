# frozen_string_literal: true

require 'scraped'

class MembersPage < Scraped::HTML
  decorator Scraped::Response::Decorator::CleanUrls

  field :member_rows do
    noko.css('div.view-members-of-parliament div.panel-display').map do |row|
      fragment row => MemberRow
    end
  end

  field :next_page do
    noko.css('.pager-next a/@href').map(&:text).first
  end
end
