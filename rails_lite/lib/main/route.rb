class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    @pattern, @http_method, @controller_class, @action_name =
    pattern, http_method, controller_class, action_name
  end

  def matches?(req)
    req_method = req.request_method.downcase.to_sym
    ((req.path =~ pattern) == 0) && req_method == http_method
  end

  def run(req, res)
    regex = Regexp.new '/\w+/(?<id>\d+)'
    match_data = regex.match(req.path)
    params = match_data ? { "id" => match_data[:id] } : {}
    controller_class.new(req, res, params).invoke_action(action_name)
  end
end
