require 'net/http'
require 'json'

def create_agent
    uri = URI('http://localhost:3000/sprinkles')
    http = Net::HTTP.new(uri.host, uri.port)
    req = Net::HTTP::Put.new(uri.path, 'Content-Type' => 'application/json')
    req.body = {sprinkle_id: 1, state: 0, key: 'kk'}.to_json
    res = http.request(req)
    puts "response #{res.body}"
rescue => e
    puts "failed #{e}"
end

create_agent

