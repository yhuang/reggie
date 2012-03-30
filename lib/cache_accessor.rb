module CacheAccessor
  def cache_accessor(*names)
    names.each do |name|
      define_method(name) do |image_url|
        begin
          response = RestClient.put "#{@base_uri}/#{@customer_id}/edge/#{name}",
                                    {:MediaPath => image_url, :MediaType => 8}.to_json,
                                    :authorization => token,
                                    :content_type => :json,
                                    :accept => :json
        rescue => e
          e
        end
      end
    end
  end
end