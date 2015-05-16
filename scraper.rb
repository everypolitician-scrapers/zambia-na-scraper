#!/bin/env ruby
# encoding: utf-8

require 'scraperwiki'
require 'nokogiri'
require 'date'
require 'open-uri'
require 'date'

require 'colorize'
require 'pry'
require 'csv'
require 'open-uri/cached'
OpenURI::Cache.cache_path = '.cache'

def noko(url)
  Nokogiri::HTML(open(url).read) 
end

def datefrom(date)
  Date.parse(date)
end

@BASE = 'http://www.parliament.gov.zm'
url = @BASE + '/members-of-parliament'
page = noko(url)

added = 0

page.css('div.view-members-of-parliament div.panel-display').each do |entry|
  # binding.pry
  party = entry.css('span.views-field-field-political-party .field-content').text.strip
  (party_name, party_id) = party.match(/(.*) \((.*)\)/).captures

  data = { 
    id: entry.css('.views-field-view-node a/@href').text.split('/').last,
    name: entry.css('.views-field-view-node a').text.split(/\s+/).join(" ").strip.gsub(/\s*,\s*MP\s*$/, ''),
    photo: entry.css('div.field-content img/@src').text,
    constituency: entry.css('span.views-field-field-constituency-name .field-content').text.strip,
    party: party_name,
    party_id: party_id,
    source: url,
    term: 2011,
  }
  puts data
  # ScraperWiki.save_sqlite([:name, :term], data)
  added += 1
end
puts "  Added #{added}"


