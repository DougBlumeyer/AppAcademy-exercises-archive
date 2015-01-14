require 'webrick'
require_relative '../lib/main/controller_base'
require_relative '../lib/main/router'

router = Router.new
server = WEBrick::HTTPServer.new(Port: 3000)
server.mount_proc('/') { |req, res| route = router.run(req, res) }
trap('INT') { server.shutdown }
server.start
