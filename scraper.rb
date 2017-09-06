#!/bin/env ruby
# encoding: utf-8
# frozen_string_literal: true

require 'scraperwiki'
require 'require_all'
require_rel 'lib'

require 'open-uri/cached'
OpenURI::Cache.cache_path = '.cache'

BASE = 'http://www.parliament.gov.zm'

def scrape(h)
  url, klass = h.to_a.first
  klass.new(response: Scraped::Request.new(url: url).response)
end

ScraperWiki.sqliteexecute('DROP TABLE data') rescue nil

# We should really extract these from the 'Next' links
pages = [
  '/members-of-parliament',
  '/members-of-parliament/page/1/0',
  '/members-of-parliament/page/2/0',
]

data = pages.flat_map do |page|
  url = URI.join(BASE, page).to_s
  scrape(url => MembersPage).member_rows.map do |row|
    row.to_h.merge(scrape(row.source => MemberPage).to_h)
  end
end

data.each { |mem| puts mem.reject { |_, v| v.to_s.empty? }.sort_by { |k, _| k }.to_h } if ENV['MORPH_DEBUG']
ScraperWiki.save_sqlite(%i[id], data)
