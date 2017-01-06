# frozen_string_literal: true
require 'scraped'

class MembersPage < Scraped::HTML
  field :member_rows do
    noko.css('div.view-members-of-parliament div.panel-display').map do |row|
      fragment row => MemberRow
    end
  end
end
