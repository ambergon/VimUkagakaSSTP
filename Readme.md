# VimUkagakaSSTP
Vimから伺かにテキストを投げられるプラグイン


## Usage
### UkagakaTalk
```
:UkagakaTalk
```
現在の行および選択した行のテキストを簡単に整形してゴーストに送信するコマンド。


### UkagakaFunc
```
:UkagakaFunc OnFunction reference0 ...
```
第一引数にゴーストの辞書に登録されている関数名をとる。
Onから始まる関数のみ呼び出せる。
Onを省略して呼び出すことが可能。
以降の引数はゴースト側からreference0..として使用することができる。



## Setting
```
let g:UkagakaGhost = "sakura.name or kero.name"
```
このプラグインから呼び出すゴーストの名前を選択できる。


## 未実装項目
### 選択肢込みのテキストを活かす
```
""選択肢を提供できる。
"Script: choice \n\n\q[text1,#temp0]\n\q[text2,#temp1]\r\n\
"Entry: #temp0,選択肢A\r\n\
"Entry: #temp1,選択肢B\r\n\
```


### レスポンスを受け取るコードの活用
```
"相手のsakura.name,kero.nameを配列[,]区切りで取得する。
"test = "EXECUTE SSTP/1.3\r\n\
"Sender: VimUkagakaSSTP\r\n\
"Command: GetName\r\n\
"Charset: UTF-8\r\n\
"\r\n"
```


## Other
参考リンク
[非公式 SSTP/1.x プロトコル仕様書](https://www.ooyashima.net/db/sstp.html)


## License
MIT


## Author
ambergon 
[twitter](https://twitter.com/Sc_lFoxGon)
