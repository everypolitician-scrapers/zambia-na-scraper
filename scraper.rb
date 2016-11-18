#!/bin/env ruby
# encoding: utf-8
# frozen_string_literal: true

require 'scraperwiki'
require 'nokogiri'
require 'pry'

require 'require_all'
require_all 'lib'

# require 'open-uri/cached'
# OpenURI::Cache.cache_path = '.cache'

page  = MembersPage.new(url: 'http://www.parliament.gov.zm/members-of-parliament')
added = 0

loop do
  page.mp_entries.each do |entry|
    mp_url = page.mp_url(entry)
    mp     = MemberPage.new(url: mp_url)
    member = MemberEntry.new(url: mp_url, noko: entry)
    ScraperWiki.save_sqlite(%i(name term), mp.to_h.merge(member.to_h))
    added += 1
  end
  next_url = page.next_page_url
  break unless next_url
  page = MembersPage.new(url: next_url)
end

puts "  Added #{added}"
