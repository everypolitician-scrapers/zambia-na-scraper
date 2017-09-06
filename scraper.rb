#!/bin/env ruby
# encoding: utf-8
# frozen_string_literal: true

require 'pry'
require 'scraperwiki'

require 'require_all'
require_rel 'lib'

require 'open-uri/cached'
OpenURI::Cache.cache_path = '.cache'

def scraper(h)
  url, klass = h.to_a.first
  klass.new(response: Scraped::Request.new(url: url).response)
end

def data_for(url)
  return [] unless url
  s = scraper(url => MembersPage)
  data = s.member_rows.map do |row|
    row.to_h.merge(scraper(row.source => MemberPage).to_h)
  end
  data + data_for(s.next_page)
end

data = data_for('http://www.parliament.gov.zm/members-of-parliament')
data.each { |mem| puts mem.reject { |_, v| v.to_s.empty? }.sort_by { |k, _| k }.to_h } if ENV['MORPH_DEBUG']

ScraperWiki.sqliteexecute('DROP TABLE data') rescue nil
ScraperWiki.save_sqlite(%i[id], data)
