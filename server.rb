#!/usr/bin/env ruby
require 'rubydns'
require 'uri'
require 'pry'
require 'active_support'
require 'active_support/core_ext'
require 'open-uri'

INTERFACES = [
  [:udp, '0.0.0.0', 53],
  [:tcp, '0.0.0.0', 53]
]

RubyDNS::run_server(INTERFACES) do
  otherwise do |t|
    type = t.resource_class.to_s
    type.slice!(0..26)
    uri = URI.parse('https://cloudflare-dns.com/dns-query')
    uri.query = { ct: 'application/dns-json', name: t.question.to_s, type: type }.to_param
    begin
      answers = JSON.parse(uri.read)['Answer']
      puts "Req: #{t.question.to_s} Type: #{type} Ans: #{answers.last['data']}" if answers.present?
      answers.present? ? t.respond!(answers.last['data']) : t.fail!(:NXDomain)
    rescue
      t.fail!(:NXDomain)
    end
  end
end