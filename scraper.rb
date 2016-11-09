#!/bin/env ruby
# encoding: utf-8
# frozen_string_literal: true

require 'scraperwiki'
require 'nokogiri'
require 'date'
require 'open-uri'
require 'pry'

require 'require_all'
require_all 'lib'

# require 'colorize'
# require 'csv'
# require 'open-uri/cached'
# OpenURI::Cache.cache_path = '.cache'

def datefrom(date)
  Date.parse(date)
end

@BASE = 'http://www.parliament.gov.zm'

# We should really extract these from the 'Next' links…
pages = [
  '/members-of-parliament',
  '/members-of-parliament/page/1/0',
  '/members-of-parliament/page/2/0',
]


added = 0
pages.each do |page|
  url = @BASE + page
  warn "Fetching #{url}"

  page = MembersPage.new(url: url)

  page.mp_entries.each do |entry|
    mp_url = page.mp_url(entry)
    mp     = MemberPage.new(url: mp_url)

    party_name = page.party_name(entry)
    party_id   = page.party_id(entry)

    data = {
      name:         page.name(entry),
      photo:        page.photo(entry),
      constituency: page.constituency(entry),
      party:        party_name,
      party_id:     party_id,
      source: url,
      term: 2011,
    }.merge(mp.to_h)
    # puts data
    ScraperWiki.save_sqlite([:name, :term], data)
    added += 1
  end
end
puts "  Added #{added}"


