# frozen_string_literal: true
require 'scraped_page'

class MembersPage < ScrapedPage
  def mp_entries
    noko.css('.view-members-of-parliament .panel-display')
  end
end