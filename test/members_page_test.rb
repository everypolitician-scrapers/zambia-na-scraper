# frozen_string_literal: true

require_relative './test_helper'
require_relative '../lib/members_page.rb'

describe MembersPage do
  around { |test| VCR.use_cassette(File.basename(url), &test) }

  subject  { MembersPage.new(response: Scraped::Request.new(url: url).response) }

  describe 'Members page with :next field' do
    let(:url) { 'http://www.parliament.gov.zm/members-of-parliament' }

    it 'returns the next page url' do
      subject.next.must_equal 'http://www.parliament.gov.zm/members-of-parliament?page=1'
    end
  end

  describe 'Members page without :next field' do
    let(:url) { 'http://www.parliament.gov.zm/members-of-parliament?page=3' }

    it 'returns an empty next page url' do
      subject.next.must_be_empty
    end
  end
end
