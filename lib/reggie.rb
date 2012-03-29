require 'json'
require 'rest_client'

class Reggie
  attr_accessor :customer_id, :token

  def initialize(args)
    @customer_id = args[:customer_id]
    @token = args[:token]

    @base_uri = "https://api.edgecast.com/v2/mcc/customers"
    @valid = false

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

  def put(method, image_url)
    begin
      response = RestClient.put "#{@base_uri}/#{@customer_id}/edge/#{method}",
                                {:MediaPath => image_url, :MediaType => 8}.to_json,
                                :authorization => @token,
                                :content_type => :json,
                                :accept => :json
    rescue => e
      e
    end
  end
end