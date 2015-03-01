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
    #regex = pattern #Regexp.new '/\w+/(?<id>\d+)'
    #match_data = regex.match(req.path)

    # match_data = pattern.match(req.path)
    # params = match_data ? { "id" => match_data[:id] } : {}
    # controller_class.new(req, res, params).invoke_action(action_name)

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
