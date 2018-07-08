class Amazonian::ProductNotFoundError < StandardError; end
class Amazonian::BotDeniedAccessError < StandardError; end
class Amazonian::Client
  attr_reader :asin

  def initialize(asin)
    @asin = asin
  end

  def call
    response = get_product
    Amazonian::Parser.new(response).call
  end

  def get_product(num_retries = 1)
    agent = Mechanize.new.tap do |web|
      web.html_parser = HtmlParser # Avoid encoding issues: https://stackoverflow.com/a/20666246/3448554
      web.user_agent_alias = (Mechanize::AGENT_ALIASES.keys - ['Mechanize']).sample # spoof every request with a random User Agent as a way to hit fewer CAPTCHA walls
    end

    begin
      # Start GET request of Amazon page using ASIN.
      response = agent.get("https://www.amazon.com/dp/#{asin}")
      if request_failed(response)
        puts "Request failed!  Trying again..."
        # On failure, recursively try again to be resilient against one-off failures
        if num_retries <= Amazonian.max_network_retries
          sleep self.class.sleep_time(num_retries)
          get_product(num_retries += 1)
        else
          handle_failed_request!(response)
        end
      else
        response
      end
    rescue Mechanize::ResponseCodeError => e
      raise Amazonian::ProductNotFoundError
    end
  end

  def request_failed(response)
    return true if response.xpath('//p[contains(text(), "Sorry, we just need to make sure")]').any? # captcha hit
    false
  end

  def handle_failed_request!(response)
    # Raise this error when we can't penetrate Amazon's CAPTCHA wall
    raise Amazonian::BotDeniedAccessError if response.xpath('//p[contains(text(), "Sorry, we just need to make sure")]').any?
  end

  # Taken from Stripe API
  # Stripe uses jitter to smooth server load; we use it to obfuscate timing detection of our scraper bot
  # https://github.com/stripe/stripe-ruby/blob/ec66c3f0f44274f885de8d13de5dce2657932121/lib/stripe/stripe_client.rb#L80
  def self.sleep_time(num_retries)
    # Apply exponential backoff with initial_network_retry_delay on the
    # number of num_retries so far as inputs. Do not allow the number to exceed
    # max_network_retry_delay.
    sleep_seconds = [Amazonian.initial_network_retry_delay * (2**(num_retries - 1)), Amazonian.max_network_retry_delay].min

    # Apply some jitter by randomizing the value in the range of (sleep_seconds
    # / 2) to (sleep_seconds).
    sleep_seconds *= (0.5 * (1 + rand))

    # But never sleep less than the base sleep seconds.
    sleep_seconds = [Amazonian.initial_network_retry_delay, sleep_seconds].max

    sleep_seconds
  end
end

class HtmlParser
  def self.parse(body, url, encoding)
    body.encode!('UTF-8', encoding, invalid: :replace, undef: :replace, replace: '')
    Nokogiri::HTML::Document.parse(body, url, 'UTF-8')
  end
end
