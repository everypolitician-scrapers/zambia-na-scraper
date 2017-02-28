# frozen_string_literal: true
require_relative './test_helper'
require_relative '../lib/member_page.rb'

describe MemberPage do
  around { |test| VCR.use_cassette(File.basename(url), &test) }

  let(:yaml_data) { YAML.load_file(subject) }
  let(:url)       { yaml_data[:url] }
  let(:response)  { MemberPage.new(response: Scraped::Request.new(url: url).response) }

  describe 'Member with complete data' do
    subject { 'test/data/CharlesRomelBanda.yml' }

    it 'gets the expected data' do
      response.to_h.must_equal yaml_data[:to_h]
    end
  end

  describe 'Member data without image' do
    subject { 'test/data/PrincessKasune.yml' }

    it 'should return nil for image' do
      response.photo.must_be_nil
    end

    it 'should contain the expected data' do
      response.to_h.must_equal yaml_data[:to_h]
    end
  end
end
