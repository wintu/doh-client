# DNS over https Client
このプログラムはDNS over httpsを使って名前解決を行うDNSサーバープログラムです。
解決先はCloudflare Public DNSを利用しております。 URL部分変えればGoogle Public DNSでも行けます。
ブログも書いております(チューニング後の記事は準備中です)
https://hacklifeinfo.com/dns-over-https-client/

## Installation
このプログラムはRubyで書かれているため、Rubyが実行できる環境下で以下のコマンドを実行してください。 
```
bundle install && bundle exec ruby server.rb
```

## Debug Mode
プログラムで何が処理されているかを表示したい場合はRubyのデバッグモードを使ってください。
```
bundle exec ruby -d server.rb
```

## Change Log
Ruby DNSライブラリの開発者(@ioquatix)さんが[async-http](https://github.com/socketry/async-http)と[async-dns](https://github.com/socketry/async-dns)を使ってパフォーマンスチューニングを行ってくれました。
ありがとうございます！！ 詳しくはプルリクみて下さい！

## LICENSE
Released under the MIT license
https://github.com/wintu/doh-client/blob/master/license