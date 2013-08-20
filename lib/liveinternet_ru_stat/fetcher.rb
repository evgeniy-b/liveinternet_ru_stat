require 'net/http'

module LiveinternetRuStatFetcher
  @cookie
  @client
  @referer

  def client
    unless @client
      @client = Net::HTTP.new 'www.liveinternet.ru'
    end

    @client
  end

  def post(path, data)
    if data.kind_of? Hash
      data = data.to_a.collect { |par| par.join '=' }.join('&')
    end

    response = client.post mkpath(path), data, headers(true)
    @referer = mkpath(path)
    response
  end

  def get(path)
    response = client.get mkpath(path), headers
    @referer = mkpath(path)
    
    #follow redirects
    if '302' == response.code
      get response['location']
    else
      response
    end
  end


  private

    def mkpath(path = '/')
      if path['liveinternet.ru']
        path.split('liveinternet.ru').last
      else
        "/stat/#{site}#{path}"
      end
    end

    def headers(form = false)
      data = {}
      data['Cookie'] = @cookie if @cookie
      data['Referer'] = "http://www.liveinternet.ru#{@referer}" if @referer

      data['Content-Type'] = 'application/x-www-form-urlencoded' if form

      data
    end
end