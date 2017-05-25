require 'money'
require 'open-uri'

class Money
  module Bank
    class WegoMoneyBank < Money::Bank::VariableExchange
      API_URL = 'http://localhost:3000/places/v1/currencies/latest'
      BASE = 'USD'

      attr_reader :ttl_in_seconds
      attr_reader :rates_expiration

      alias super_get_rate get_rate

      def ttl_in_seconds=(value)
        @ttl_in_seconds = value
        refresh_rates_expiration if ttl_in_seconds
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
          refresh_rates_expiration
          update_rates
        end
      end

      def expired?
        Time.now > rates_expiration
      end

      def refresh_rates_expiration
        @rates_expiration = Time.now + ttl_in_seconds
      end

    end
  end
end
