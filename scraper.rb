#!/bin/env ruby
# encoding: utf-8
# frozen_string_literal: true

require 'scraperwiki'
require 'require_all'
require_rel 'lib'

require 'open-uri/cached'
OpenURI::Cache.cache_path = '.cache'

def scrape(h)
  url, klass = h.to_a.first
  klass.new(response: Scraped::Request.new(url: url).response)
end

def data_for_members(url)
  members_page = (scrape url => MembersPage)
  members_data = members_page.member_rows.map do |row|
    mp_page = scrape row.source => MemberPage
    row.to_h
       .merge(mp_page.to_h)
       .merge(source: url, term: 2011)
  end
  next_page = members_page.next
  return members_data if next_page.empty?
  members_data.concat(data_for_members(next_page))
end

ScraperWiki.sqliteexecute('DROP TABLE data') rescue nil
data = data_for_members('http://www.parliament.gov.zm/members-of-parliament')
ScraperWiki.save_sqlite(%i[name term], data)
