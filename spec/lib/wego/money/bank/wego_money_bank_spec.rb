require 'spec_helper'

RSpec.describe Money::Bank::WegoMoneyBank do
  subject { Money::Bank::WegoMoneyBank.new }

  describe '#reset_expire_time' do
    before do
      subject.ttl_in_seconds = 1
    end

    it('sets the rates expiration') do
      expect(subject.expire_time).to be > Time.now
    end
  end

  describe '#expired?' do
    before do
      subject.ttl_in_seconds = 1
    end

    it ('returns if rates has expired') do
      expect(subject.expired?).to be(false)
    end
  end

  describe '#pair_rate_using_base' do
    before do
      subject.stub(:fetch_rate).with('USD', 'SGD') { 2 }
      subject.stub(:fetch_rate).with('USD', 'PHP') { 4 }
    end

    it ('returns rate using rates using base') do
      expect(subject.pair_rate_using_base('SGD', 'PHP')).to eq(2)
    end
  end

  describe '#inverse_rate' do
    before do
      subject.stub(:super_get_rate).with('USD', 'PHP') { 2 }
    end

    it ('returns the rate using inverse rate') do
      expect(subject.inverse_rate('PHP', 'USD')).to eq(0.5)
    end
  end

  describe '#exchange_rates' do
    before do
      stub_api
    end

    it ('return an array of exchange_rates') do
      expect(subject.exchange_rates.size).to eq(4)
    end
  end

  describe '#update_rates' do
    before do
      stub_api
      subject.update_rates
    end

    it ('update the rates with the current exchange rates') do
      expect(subject.get_rate('USD', 'SGD').to_f).to eq 2
      expect(subject.get_rate('SGD', 'USD').to_f).to eq 0.5
      expect(subject.get_rate('SGD', 'PHP').to_f).to eq 3
    end
  end

end
