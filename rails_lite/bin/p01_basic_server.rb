require 'webrick'

server = WEBrick::HTTPServer.new(:Port => 3000)

server.mount_proc("/") { |req, res| res.body = "'#{req.path}'" }

trap('INT') { server.shutdown }

server.start
