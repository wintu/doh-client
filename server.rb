#!/usr/bin/env ruby

require 'json'

require 'async'

require 'async/dns'

require 'async/io/host_endpoint'

require 'async/http/url_endpoint'
require 'async/http/reference'
require 'async/http/client'

# RubyDNS is implemented by this class.
class Server < Async::DNS::Server
  def initialize(*)
    super
    
    # This will cache one or more open connections.
    @endpoint = Async::HTTP::URLEndpoint.parse("https://cloudflare-dns.com/dns-query")
    @client = Async::HTTP::Client.new(@endpoint)
  end
  
  def process(name, resource_class, transaction)
    type = resource_class.to_s.split('::').last
    
    # This generates the appropriate request URL:
    reference = Async::HTTP::Reference.parse(@endpoint.url.path, {
      ct: 'application/dns-json',
      name: name,
      type: type,
    })

    if resource_class.to_s.split('::')[3] == 'Generic'
      transaction.fail!(:NXDomain)
      return
    end
    
    response = @client.get(reference)
    answers = JSON.parse(response.read)['Answer']
    
    if !answers.nil? && answers.any?
      transaction.append_question!
      
      answers.each do |answer|
        if klass = Resolv::DNS::Resource.get_class(answer["type"], resource_class::ClassValue)
          if klass < Resolv::DNS::Resource::DomainName
            resource = klass.new(Resolv::DNS::Name.create(answer["data"]))
          else
            resource = klass.new(answer["data"])
          end
          
          transaction.response.add_answer(answer["name"], answer["TTL"], resource)
        end
      end
    else
      transaction.fail!(:NXDomain)
    end
  end
end

INTERFACES = [
  [:udp, '0.0.0.0', 5300],
  [:tcp, '0.0.0.0', 5300]
]

server = Server.new(INTERFACES)
server.run
