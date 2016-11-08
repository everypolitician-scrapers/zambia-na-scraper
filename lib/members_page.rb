# frozen_string_literal: true
require 'scraped_page'

class MembersPage < ScrapedPage
  def mp_entries
    noko.css('.view-members-of-parliament .panel-display')
  end

  def mp_url(entry)
    URI.join(url, entry.css('.views-field-view-node a/@href').text).to_s
  end

  def party_name(entry)
    split_party(entry).first
  end

  def party_id(entry)
    split_party(entry).last
  end

  private

  def split_party(entry)
    @split_party ||= entry
                     .css('span.views-field-field-political-party .field-content')
                     .text
                     .strip
                     .match(/(.*) \((.*)\)/)
                     .captures
  end
end
