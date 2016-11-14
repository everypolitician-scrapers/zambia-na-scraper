# frozen_string_literal: true

class MemberEntry
  include FieldSerializer

  def initialize(url:, noko:)
    @url  = url
    @noko = noko
  end

  field :name do
    noko
      .css('.views-field-view-node a')
      .text
      .split(/\s+/)
      .join(' ')
      .strip
      .gsub(/\s*,\s*MP\s*$/, '')
  end

  field :photo do
    noko.css('div.field-content img/@src').text
  end

  field :constituency do
    noko
      .css('span.views-field-field-constituency-name .field-content')
      .text
      .strip
  end

  field :party do
    split_party.first
  end

  field :party_id do
    split_party.last
  end

  field :source do
    url
  end

  private

  attr_reader :url, :noko

  def split_party
    @split_party ||= noko
                     .css('.views-field-field-political-party .field-content')
                     .text
                     .strip
                     .match(/(.*) \((.*)\)/)
                     .captures
  end
end
