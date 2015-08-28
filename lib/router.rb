class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    @pattern = pattern
    @http_method = http_method
    @controller_class = controller_class
    @action_name = action_name
  end

  # Checks if pattern matches path and method matches request method
  def matches?(req)
    (http_method == req.request_method.downcase.to_sym) && !!(pattern =~ req.path)
  end

  # Use pattern to pull out route params
  # Instantiate controller and call controller action
  def run(req, res)
    match_data = @pattern.match(req.path)

    route_params = Hash[match_data.names.zip(match_data.captures)]

    @controller_class
      .new(req, res, route_params)
      .invoke_action(action_name)
  end
end

class Router
  attr_reader :routes

  def initialize
    @routes = []
  end

  # simply adds a new route to the list of routes
  def add_route(pattern, method, controller_class, action_name)
    route = Route.new(pattern, method, controller_class, action_name)
    @routes << route
  end

  # Evaluate the proc in the context of the instance
  def draw(&proc)
    self.instance_eval(&proc)
  end

  # When these methods are called a route is added
  [:get, :post, :put, :delete].each do |http_method|
    define_method(http_method) do |pattern, controller_class, action_name|
      # pattern, controller_class, action_name are given
      add_route(pattern, http_method, controller_class, action_name)
    end
  end

  # Returns route that matches the request
  def match(req)
    routes.find { |route| route.matches?(req) }
  end

  # Run on a matched route or throw error
  def run(req, res)
    matched_route = match(req)

    if matched_route.nil?
      res.status = 404
    else
      matched_route.run(req, res)
    end
  end
end
