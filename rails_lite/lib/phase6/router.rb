module Phase6
  class Route
    attr_reader :pattern, :http_method, :controller_class, :action_name

    def initialize(pattern, http_method, controller_class, action_name)
      @pattern, @http_method, @controller_class, @action_name =
        pattern, http_method, controller_class, action_name
    end

    # checks if pattern matches path and method matches request method
    def matches?(req)
      #debugger
      ((req.path =~ pattern) == 0) && req.request_method.downcase.to_sym == http_method
    end

    # use pattern to pull out route params (save for later?)
    # instantiate controller and call controller action
    def run(req, res)
      #regex = Regexp.new '/(?<param_key>\w+)/(?<id>\d+)'
      #match_data = regex.match(req.path)
      match_data = pattern.match(req.path)
      #params = match_data ? { "#{match_data[:param_key].singularize}_id".to_sym => match_data[:id] } : {}
      #debugger
      #params = match_data.length > 1 ? { "id" => match_data[:id] } : {}
      params = {}
      match_data.to_a.drop(1).each_with_index do |md, idx|
        #params[match_data.names[idx].to_sym] = md
        params[match_data.names[idx]] = md
      end
      #debugger
      controller_class.new(req, res, params).invoke_action(action_name)
    end
  end

  class Router
    attr_reader :routes

    def initialize
      @routes = []
    end

    # simply adds a new route to the list of routes
    def add_route(pattern, method, controller_class, action_name)
      @routes << Route.new(pattern, method, controller_class, action_name)
    end

    # evaluate the proc in the context of the instance
    # for syntactic sugar :)
    def draw(&proc)
      # THIS IS THE PROC IT'S GETTING PASSED:
      # get Regexp.new("^/cats$"), Cats2Controller, :index
      # get Regexp.new("^/cats/(?<cat_id>\\d+)/statuses$"), StatusesController, :index
      self.instance_eval(&proc)
    end

    # make each of these methods that
    # when called add route
    [:get, :post, :put, :delete].each do |http_method|
      define_method(http_method) do |pattern, controller_class, action_name|
        add_route(pattern, http_method, controller_class, action_name)
      end
    end

    # should return the route that matches this request
    def match(req)
      @routes.each { |route| return route if route.matches?(req) }

      nil
    end

    # either throw 404 or call run on a matched route
    def run(req, res)
      route_to_run = match(req)
      #p route_to_run
      route_to_run ? route_to_run.run(req, res) : res.status = 404
    end
  end
end
