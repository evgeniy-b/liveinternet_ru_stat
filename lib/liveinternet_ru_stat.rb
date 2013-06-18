require 'nokogiri'
require 'liveinternet_ru_stat/fetcher.rb'
require 'liveinternet_ru_stat/queries.rb'

class LiveinternetRuStat
  include LiveinternetRuStatFetcher
  include LiveinternetRuStatQueries

  attr_reader :site

  def initialize(site, password)
    @site = site
    authenticate password
  end

  def authenticate(password)
    resp = get '/'
    rnd = resp.body.split('name=rnd value="').last.split('"').first
    @cookie = resp.response['set-cookie'].split('; ')[0]

    resp = post '/', rnd: rnd,
                     need_password: "yes",
                     url: "http://#{site}",
                     password: password

    if '302' == resp.code
      @cookie += '; ' + resp.response['set-cookie'].split('; ')[0]
      get resp.response['location']

    else
      raise 'liveinternet.ru/stat authentication failed'
    end
  end
end