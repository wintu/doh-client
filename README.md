# DNS over https Client
このプログラムはDNS over httpsを使って名前解決を行うDNSサーバープログラムです。
解決先はCloudflare Public DNSを利用しております。 URL部分変えればGoogle Public DNSでも行けます。

## Installation
このプログラムはRubyで書かれているため、Rubyが実行できる環境下で以下のコマンドを実行してください。
````
bundle install && sudo bundle exec ruby server.rb
```