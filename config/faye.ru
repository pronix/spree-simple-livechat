# This file is used by Rack-based servers to start the application.
require 'faye'

faye_server = Faye::RackAdapter.new(:mount => '/faye', :timeout => 5)
run faye_server