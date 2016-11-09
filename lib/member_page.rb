# frozen_string_literal: true
require 'scraped_page'

class MemberPage < ScrapedPage
  field :id do
    url.to_s.split('/').last
  end
end
