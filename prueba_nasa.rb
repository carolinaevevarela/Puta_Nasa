require 'uri'
require 'openssl'
require 'net/http'
require 'json'

def request(url, key = "Ae4TVmZAByLfyhGPRmJxnr4QF4eDpiFbFBpNa4cE")

  url = URI("#{url}&api_key=#{key}")


  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  #http.ssl_version = OpenSSL::SSL::OP_NO_SSLv2 + OpenSSL::SSL::OP_NO_SSLv3 + OpenSSL::SSL::OP_NO_COMPRESSION

  request = Net::HTTP::Get.new(url)
  request["cache-control"] = 'no-cache'
  request["Postman-Token"] = 'f7c94d0f-4b59-4e49-9c74-b7ba2289dc23'

  response = http.request(request)
  JSON.parse(response.read_body)
end

data = request("https://api.nasa.gov/mars-photos/api/v1/rovers/curiosity/photos?sol=10")


def build_web_page(data)
  photos = data['photos'].map{|x| x['img.src']}
  html = "<html>\n<head>\n</head>\n<body>\n<ul>\n"
  photos.each do |photo|
    html += "<li><img src='#{photo}'></li>"
  end
    html += "</ul>\n</body>\<html>"
  File.write('output.html', html)
end

build_web_page(data)

def photos_count(data)
  data["photos"].map{|x| x['camera']['name']}.group_by{|x| x}.map{|k, v| [k,v.count]}
end

puts photos_count(data)
