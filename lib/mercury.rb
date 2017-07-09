require "httparty"

class Mercury
  BASE_URL = 'https://mercury.postlight.com/parser?url='
  def self.parse(url)
    OpenStruct.new JSON.parse(request(url).body)
  end

  private

  def self.request(url)
    formed_url = BASE_URL + url
    HTTParty.get(formed_url, {headers: headers})
  end

  def self.headers
    {
      "x-api-key"=> Rails.application.secrets.mercury_token,
      "Content-Type"=> "application/json",
    }
  end
end
