# -*- coding: utf-8 -*-
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'config', 'environment'))

require File.dirname(__FILE__) + "/../lib/jabber_gateway"
require "daemon-spawn"
class ChatDaemon < DaemonSpawn::Base
  def start(args)
    JabberGateway.start
  end

  def stop
    puts "Stopping JabberGateway daemon..."
  end
end

# Start daemon!
ChatDaemon.spawn!(:working_dir => File.join(File.dirname(__FILE__) + "/../"),
                   :log_file => File.dirname(__FILE__) + "/../log/chat.log",
                   :pid_file => File.dirname(__FILE__) + "/../tmp/pids/chat.pid",
                   :sync_log => true,
                   :singleton => true)


