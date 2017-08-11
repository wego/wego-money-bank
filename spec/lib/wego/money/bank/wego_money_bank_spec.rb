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

    context 'no rates from cache and API' do
      it 'returns empty array' do
        allow(subject).to receive(:fetch_from_cache).and_return nil
        allow(subject).to receive(:fetch_from_url).and_return nil
        expect(subject.exchange_rates).to be_empty
      end
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

  describe '#refresh_rates_cache' do
    before do
      subject.cache = data_file('latest.json')
      subject.stub(:fetch_from_url){ 'text' }
    end

    it ('refresh the rates cache') do
      subject.refresh_rates_cache
      expect(open(subject.cache).read).to eq('text')
    end
  end

  describe '#fetch_from_cache' do
    before do
      stub_api
      subject.cache = data_file('latest.json')
      subject.refresh_rates_cache
    end

    it ('reads rates from cache') do
      rates = JSON.parse subject.fetch_from_cache

      expect(rates[0]['code']).to eq('SGD')
      expect(rates[1]['code']).to eq('AED')
      expect(rates[2]['code']).to eq('PHP')
      expect(rates[3]['code']).to eq('VND')
    end
  end

  describe '#fetch_from_url' do

    context 'request is more than 3 seconds' do
      let(:error) { OpenURI::HTTPError.new('504 Gateway Timeout', nil) }
      before do
        WebMock.stub_request(:get, Money::Bank::WegoMoneyBank::API_URL).to_raise error
      end
      it 'returns nil' do
        expect(subject.fetch_from_url).to eq nil
      end
    end
  end

end
