require 'cache_accessor'
require 'json'
require 'rest_client'

class Reggie
  extend CacheAccessor

  attr_accessor :customer_id, :token
  cache_accessor :purge, :load

  def initialize(args)
    @customer_id = args[:customer_id]
    @token = args[:token]

    @base_uri = "https://api.edgecast.com/v2/mcc/customers"

    begin
      response = RestClient.get "#{@base_uri}/#{@customer_id}/compression",
                                :authorization => @token,
                                :accept => :json
      @valid = true if response.code == 200
    rescue => e
    end
  end

  def valid?
    @valid
  end
end