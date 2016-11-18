# frozen_string_literal: true
require 'scraped_page'

class MembersPage < ScrapedPage
  field :mp_entries do
    noko.css('.view-members-of-parliament .panel-display')
  end

  field :next_page_url do
    path = noko.css('.pager-next a/@href').text
    return if path.empty?
    URI.join(url, URI.encode(URI.decode(path))).to_s
  end

  def mp_url(entry)
    URI.join(url, entry.css('.views-field-view-node a/@href').text).to_s
  end
end
