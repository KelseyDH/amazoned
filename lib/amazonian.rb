require 'active_support/core_ext/string'
require 'amazonian/version'
require 'amazonian/client'
require 'amazonian/parser'
require 'mechanize'
require 'nokogiri'
require 'byebug'

module Amazonian
  @max_network_retries = 3
  @max_network_retry_delay = 2.3
  @initial_network_retry_delay = 1.1 # requests under a second could flag us as a scraping bot


  class << self
    attr_reader :max_network_retry_delay, :initial_network_retry_delay
  end

  def self.max_network_retries
    @max_network_retries
  end

  def self.max_network_retries=(val)
    @max_network_retries = val.to_i
  end
end
