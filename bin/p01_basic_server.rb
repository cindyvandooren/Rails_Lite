require 'webrick'

server = WEBrick::HTTPServer.new(:Port => 3000)

server.mount_proc("/") do |request, response|
  response.content_type = "text/text"
  response.body = request.path
end

#Stop server when using Ctrl-C
trap('INT') do
  server.shutdown
end

server.start
