# by Matt Harzewski
# Read more: http://www.webmaster-source.com/2013/09/25/finding-a-websites-favicon-with-ruby/
require "httparty"
require "nokogiri"
require "base64"

class Favicon
  attr_reader :host
  attr_reader :uri
  attr_reader :base64

  def initialize(host)
    @host = host
  end

  def url
    ico_url || html_tag_url
  end

  def ico_url
    uri = URI::HTTP.build({host: @host, path: '/favicon.ico'}).to_s
    res = HTTParty.get(uri)

    uri if res.code == 200
  end

  def html_tag_url
    uri = URI::HTTP.build({host: @host, path: '/'}).to_s
    res = HTTParty.get(uri)


    html_tags(res).detect do |tag|
      uri = icon_uri(tag)
      res = HTTParty.get(uri)

      break uri if res.code == 200
    end
  end

  private

  def icon_uri(tag)
    taguri = URI(tag['href'])

    unless taguri.host.to_s.length < 1
      taguri.to_s
    else
      URI.join(uri, taguri).to_s
    end
  end

  def html_tags(page)
    doc = Nokogiri::HTML(page)
    doc.xpath('//link[@rel="icon"]').reverse
  end
end
