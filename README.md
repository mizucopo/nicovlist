nicovlist
==================================================

ニコニコ動画のランキングRSSを自動的にマイリスト化するウェブアプリ。



作成目的
--------------------------------------------------

作業するときにBGMをかけながら作業したいなという思いがあり、
ついでならVOCALOIDの最新の人気の曲を聞きながら作業できないかなと思い、作成に至る。
どうせ作るなら、慣れている PHP を離れ、
サーバーサイドは Ruby on Rails、クライアントサイドは、Backbone.js という環境で勉強しながら構築しました。



アプリケーション設定
--------------------------------------------------

**config/database.yml**

特に特殊なことはしておりませんので、データベースに依存していない実装となっております。

**config/application.rb**

* config.nicovideo_rss : ランキングのRSSのURL

**config/environments/development.rb , config/environments/production.rb , config/environments/test.rb**

* config.nicovideo_mail : ニコニコ動画のログインID
* config.nicovideo_password : ニコニコ動画のログインパスワード



マイリストの作り方
--------------------------------------------------

    $ rake run script/create_mylist.rb

上記コマンドを実行する。