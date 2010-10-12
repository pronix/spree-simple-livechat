# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

class SimpleLivechatExtension < Spree::Extension
  version "1.0"
  description "Describe your extension here"
  url "http://yourwebsite.com/simple_livechat"

  # Please use simple_livechat/config/routes.rb instead for extension routes.

  def self.require_gems(config)
    config.gem 'easy-gtalk-bot'
    config.gem "daemon-spawn", :lib => "daemon-spawn", :version => '= 0.2.0'
    config.gem "daemons"
    config.gem 'eventmachine', :version => '0.12.10'
    config.gem "json"
    config.gem "escape_utils", :version => "~> 0.1.6"
    config.gem "faye"
   end

  def activate

    Spree::BaseController.class_eval do
      before_filter :set_uid
      private
      def set_uid
        session[:uid] ||= Digest::SHA1.hexdigest("#{rand(100)}--#{Time.now.to_i.to_s}")[4..11]
      end
    end

    AppConfiguration.class_eval do
      preference :jabber_account, :string
      preference :jabber_password, :string
      preference :support_jabber_account, :string
    end


    # make your helper avaliable in all views
    Spree::BaseController.class_eval do
      helper do
        def livechat(options)

        end
      end
    end
  end
end
