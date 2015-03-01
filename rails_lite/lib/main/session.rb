require 'json'
require 'webrick'

class Session

  def initialize(req)
    cookie = req.cookies.find { |c| c.name == '_rails_lite_app' }
    @data = cookie ? JSON.parse(cookie.value) : {}
    #@data.each { |k,v| self[k] = v }
  end

  def [](key)
    @data[key]
  end

  def []=(key, val)
    @data[key] = val
  end

  def store_session(res)
    res.cookies << WEBrick::Cookie.new('_rails_lite_app', @session.to_json)
  end
end
