require 'money'
require 'open-uri'

class Money
  module Bank
    class WegoMoneyBank < Money::Bank::VariableExchange
      API_URL = 'https://srv.wego.com/places/v1/currencies/latest'
      BASE = 'USD'

      attr_accessor :cache
      attr_reader :ttl_in_seconds
      attr_reader :expire_time

      alias super_get_rate get_rate

      def ttl_in_seconds=(value)
        @ttl_in_seconds = value
        reset_expire_time if ttl_in_seconds
        @ttl_in_seconds
      end

      def url
        API_URL
      end

      def base
        BASE
      end

      def fetch
        fetch_from_cache || fetch_from_url
      end

      def update_rates
        refresh_rates_cache

        exchange_rates.each do |exchange_rate|
          rate = exchange_rate['rate'].to_f
          currency = exchange_rate['code']
          base = exchange_rate['base']

          if Money::Currency.find(currency)
            set_rate(base, currency, rate)
            set_rate(currency, base, 1.0 / rate)
          end
        end
      end

      def fetch_from_url
        open(url).read
      end

      def fetch_from_cache
        open(cache).read if cache
      end

      def exchange_rates
        JSON.parse(fetch)
      end

      def get_rate(from, to)
        expire_rates
        fetch_rate(from, to) || pair_rate_using_base(from, to)
      end

      def fetch_rate(from, to)
        super_get_rate(from, to) || inverse_rate(from, to)
      end

      def inverse_rate(from, to)
        rate = super_get_rate(to, from)

        if rate
          rate = 1.0 / rate
          add_rate(from, to, rate)
        end

        rate
      end

      def pair_rate_using_base(from, to)
        from_rate = fetch_rate(base, from)
        to_rate = fetch_rate(base, to)

        if from_rate && to_rate
          rate = to_rate / from_rate
          add_rate(from, to, rate)
          return rate
        end
      end

      def expire_rates
        if ttl_in_seconds && expired?
          update_rates
          reset_expire_time
        end
      end

      def expired?
        Time.now > expire_time
      end

      def reset_expire_time
        @expire_time = Time.now + ttl_in_seconds
      end

      def refresh_rates_cache
        json_rates = fetch_from_url
        if cache
          open(cache, 'w') do |f|
            f.write(json_rates)
          end
        end
      end

    end
  end
end
