#!/bin/env ruby
# encoding: utf-8
# frozen_string_literal: true

require 'date'
require 'nokogiri'
require 'open-uri'
require 'scraperwiki'
require 'require_all'
require_rel 'lib'

require 'open-uri/cached'
OpenURI::Cache.cache_path = '.cache'

def noko(url)
  Nokogiri::HTML(open(url).read)
end

def datefrom(date)
  Date.parse(date)
end

BASE = 'http://www.parliament.gov.zm'

# We should really extract these from the 'Next' links
pages = [
  '/members-of-parliament',
  '/members-of-parliament/page/1/0',
  '/members-of-parliament/page/2/0',
]

added = 0
pages.each do |page|
  url = URI.join(BASE, page).to_s
  warn "Fetching #{url}"

  MembersPage.new(response: Scraped::Request.new(url: url).response)
             .member_rows
             .each do |row|
    mp_page = MemberPage.new(response: Scraped::Request.new(url: row.member_url).response)

    data = {
      id:           entry.id,
      name:         entry.name,
      photo:        entry.photo,
      constituency: entry.constituency,
      party:        entry.party_name,
      email:        mp_page.email,
      birth_date:   mp_page.birth_date,
      party_id:     entry.party_id,
      source:       url,
      term:         2011,
    }
    # puts data
    ScraperWiki.save_sqlite(%i(name term), data)
    added += 1
  end
end
puts "  Added #{added}"
