# frozen_string_literal: true
require 'scraped'

class MembersPage < Scraped::HTML
  decorator Scraped::Response::Decorator::AbsoluteUrls

  field :member_rows do
    noko.css('div.view-members-of-parliament div.views-row').map do |row|
      fragment row => MemberRow
    end
  end
end
