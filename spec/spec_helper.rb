$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "money/bank/wego_money_bank"
require "webmock/rspec"
require "monetize"

RSpec.configure do |config|
end

def data_file(file)
  File.expand_path(File.join(File.dirname(__FILE__), 'data', file))
end

def read_file(file)
  File.read(file)
end

def stub_api
  fixtures = File.expand_path(File.join(File.dirname(__FILE__), 'fixtures', 'currencies.json'))

  WebMock.stub_request(:get, Money::Bank::WegoMoneyBank::API_URL)
    .to_return(status: 200, body: read_file(fixtures))
end
