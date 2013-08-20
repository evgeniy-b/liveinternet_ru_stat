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
    @cookie = ''

    resp = get '/'
    rnd = resp.body.split('name=rnd value="').last.split('"').first
    @cookie = resp.response['set-cookie'].split('; ')[0] if resp.response['set-cookie']

    resp = post '/', rnd: rnd,
                     need_password: "yes",
                     url: "http://#{site}",
                     password: password

    if '302' == resp.code
      @cookie += '; ' + resp.response['set-cookie'].split('; ')[0]
      get resp.response['location']

      # check mirrors
      if !@referer[site] && @referer =~ /\/stat\/([^\/]+)\//
        @site = $1
      end

    else
      raise 'liveinternet.ru/stat authentication failed'
    end
  end
end