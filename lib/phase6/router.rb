require 'byebug'

module Phase6
  class Route
    attr_reader :pattern, :http_method, :controller_class, :action_name

    def initialize(pattern, http_method, controller_class, action_name)
      @pattern = pattern
      @http_method = http_method
      @controller_class = controller_class
      @action_name = action_name
    end

    # checks if pattern matches path and method matches request method
    def matches?(req)
      http_method == req.request_method.downcase.to_sym && pattern === req.path
    end

    # use pattern to pull out route params (save for later?)
    # instantiate controller and call controller action

    def run(req, res)
      route_params = {}
      match_data = pattern.match(req.path)
      match_data.names.each do |key|
        route_params[key] = match_data[key]
      end

      # action_name, pattern and controller_class are coming from input
      # from client.
      controller_class.new(req, res, route_params).invoke_action(action_name)
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

    # evaluate the proc in the context of the instance
    # for syntactic sugar :)
    def draw(&proc)
      self.instance_eval(&proc)
    end

    # make each of these methods that
    # when called add route
    # def get(pattern, controller_class, action_name)
    #   add_route(pattern, http_method, controller_class, action_name)
    # end

    [:get, :post, :put, :delete].each do |http_method|
      define_method("#{http_method.to_sym}") do |pattern, controller_class, action_name|
        # pattern, controller_class, action_name are assumed to be given
        add_route(pattern, http_method, controller_class, action_name)
      end
    end

    # should return the route that matches this request
    def match(req)
      @routes.find { |route| route.matches?(req) }
    end

    # either throw 404 or call run on a matched route
    def run(req, res)
      matched_route = match(req)
      if matched_route.nil?
        res.status=(404)
      else
        matched_route.run(req, res)
      end
    end
  end
end
