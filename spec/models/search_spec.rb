# frozen_string_literal: true
require 'rails_helper'

describe Search do
  describe '.search' do
    let(:query) { 'search' }
    let(:type) { 'Answer' }

    it 'query nil?' do
      expect(described_class.search(nil)).to be_nil
    end

    it 'search if type nil' do
      expect(ThinkingSphinx).to receive(:search)
        .with(query, page: 1, per_page: 20)
      described_class.search(query)
    end

    it 'search with type' do
      expect(ThinkingSphinx).to receive(:search)
        .with(query, classes: [type.constantize], page: 1, per_page: 20)
      described_class.search(query, type)
    end
  end
end
