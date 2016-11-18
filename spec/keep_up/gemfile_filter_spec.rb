require 'spec_helper'

describe KeepUp::GemfileFilter do
  describe '.apply' do
    let(:dependency) { double('dep', name: 'foo', version: '1.2.0') }

    it 'keeps indenting intact' do
      contents = "  gem 'foo', '1.1.0'"

      result = described_class.apply(contents, dependency)
      expect(result).to eq "  gem 'foo', '1.2.0'"
    end
  end
end
