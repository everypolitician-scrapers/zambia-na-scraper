# frozen_string_literal: true
require 'scraped_page'

class MembersPage < ScrapedPage
  field :mp_entries do
    noko.css('.view-members-of-parliament .panel-display')
  end

  def mp_url(entry)
    URI.join(url, entry.css('.views-field-view-node a/@href').text).to_s
  end
end
