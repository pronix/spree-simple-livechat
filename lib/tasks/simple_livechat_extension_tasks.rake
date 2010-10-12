namespace :spree do
  namespace :extensions do
    namespace :simple_livechat do
      desc "Copies public assets of the Simple Livechat to the instance public/ directory."
      task :update => :environment do
        is_svn_git_or_dir = proc {|path| path =~ /\.svn/ || path =~ /\.git/ || File.directory?(path) }
        Dir[SimpleLivechatExtension.root + "/public/**/*"].reject(&is_svn_git_or_dir).each do |file|
          path = file.sub(SimpleLivechatExtension.root, '')
          directory = File.dirname(path)
          puts "Copying #{path}..."
          mkdir_p RAILS_ROOT + directory
          cp file, RAILS_ROOT + path
        end
        cp "#{SimpleLivechatExtension.root}/lib/jabber_gateway.rb", "#{RAILS_ROOT}/lib/jabber_gateway.rb"
        cp "#{SimpleLivechatExtension.root}/script/daemon_chat.rb", "#{RAILS_ROOT}/script/daemon_chat.rb"
      end
    end
  end
end
