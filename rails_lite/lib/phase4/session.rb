require 'json'
require 'webrick'
require 'byebug'

module Phase4
  class Session
    # find the cookie for this app
    # deserialize the cookie into a hash
    def initialize(req)
      #@req = req
      @session = {}
      #debugger
      cookie = req.cookies.find { |c| c.name == '_rails_lite_app' }
      @data = cookie ? JSON.parse(cookie.value) : {}
      @data.each { |k,v| self[k] = v }
    end

    def [](key)
      @session[key]
    end

    def []=(key, val)
      @session[key] = val
    end

    # serialize the hash into json and save in a cookie
    # add to the responses cookies
    def store_session(res)
      #res.cookies << { name: '_rails_lite_app', value: @session.to_json }
      #debugger
      #res.cookies['_rails_lite_app'] = @session.to_json
      #res.cookies << @session.to_json
      #debugger
      res.cookies << WEBrick::Cookie.new('_rails_lite_app', @session.to_json)
    end
  end
end
