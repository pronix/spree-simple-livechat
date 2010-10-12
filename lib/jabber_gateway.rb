# -*- coding: utf-8 -*-
class JabberGateway < EM::Connection
  class << self
    def start
      @bot = GTalk::Bot.new(:email => Spree::Config.get("jabber_account"), :password => Spree::Config.get("jabber_password"))
      @bot.get_online
      loop do
        begin
          GC.start
          EM.epoll if EM.epoll?
          EM.run do
            client = Faye::Client.new('http://localhost:9292/faye')

            client.subscribe '/from/*' do |message|
              @user = message['user']
              @msg = message['msg']
              puts "[#{ @user }]: #{ message['msg'] }"
              [Spree::Config.get("support_jabber_account").split(',')].each do |gaccount|
                @bot.message gaccount , "##{@user}: #{@msg}"
              end
            end

            @bot.on_message do |from, text|
              @text = text
              @uid_user = @text.match(/#(\w+):/) && $1
              @msg = @text.match(/#(\w+):(.*)/) && $2
              puts "[#{ @uid_user }]: #{ @msg }"
              unless @uid_user.nil? || @msg.nil?
                client.publish("/to/#{@uid_user}",{ :msg => @msg, :time => Time.now })
              end
            end

          end
        rescue Interrupt
          puts "Shuting down..."
          exit
        rescue
          puts $!.message
        end
      end
    end

  end # end class << self
end
