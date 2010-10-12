= Simple Chat

Переписка покупателя с менеджером.
=================================
Расширение позволяет покупателю со страницы магазина вести переписку с менеджером, а менеджер может отвечать из любого jabber клиента.

Установка
---------
 script/extension install  git://github.com/pronix/spree-simple-livechat.git

Необходимые gems
----------------
    config.gem 'easy-gtalk-bot'
    config.gem "daemon-spawn", :lib => "daemon-spawn"
    config.gem "daemons"
    config.gem 'eventmachine', :version => '0.12.10'
    config.gem "json"
    config.gem "escape_utils", :version => "~> 0.1.6"
    config.gem "faye"

На стороне клиента
==================

После установки необходимо добвать следующие js и css файлы
-----------------------------------------------------------
stylesheet_link_tag "chat"
javascript_include_tag 'jquery'
javascript_include_tag 'chat'
javascript_include_tag 'faye.js', - файл js от faye, путь указывает на сервер faye

Для создание формы чата необходимо
-----------------------------------
  <script type="text/javascript">
    //  Faye.Logging.logLevel = 'debug';
    //  Faye.logger = function(message) { console.log(message);  };
    var faye_url = 'http://'+window.location["host"]+':9292/faye'; // урл сервера faye
    var client = new Faye.Client(faye_url, {timeout: 10 });
    $(function(){
        simplechat({"user_uid": "<%= session[:uid] %>", "title": "manager",
                        "send": function(data){
                                 var channel = "/from/"+data["user_uid"];   /* канал faye для отправки сообщения */
                                 client.publish(channel, {"user": data["user_uid"], "msg": data["message"]});
                                },
                      "listen": function(){
                                   client.subscribe('/to/<%= session[:uid] %>', function(message) {  /* канал faye для приема сообщения */
                                   this.show_message(message["msg"]);
                                });
                    }
                 })
    });
  </script>


На стороне сервера
==================
* Выполнить кипирование файлов  rake spree:extensions:simple_livechat:update
  Будут скопированы файлы из public( стандартный таск) и файлы из script и lib
* Запустить сервер faye: rackup ./config/faye.ru -s thin -E production (сервер faye нужно обязательно запускать с -E production)
* запустить spree настроить в админке jabber аккаунту (авторизовав каждый друг у друга)
* запустить шлюз jabber - site
  RAILS_ENV=production ./script/daemon_chat.rb start



