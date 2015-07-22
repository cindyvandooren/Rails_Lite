require 'uri'
require 'byebug'

module Phase5
  class Params
    attr_accessor :params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    #
    # You haven't done routing yet; but assume route params will be
    # passed in as a hash to `Params.new` as below:
    # In here route_params' keys can be either symbols or strings, getter
    # method will make sure that we can get both.
    def initialize(req, route_params = {})
      @params = route_params
      parse_www_encoded_form(req.query_string) unless req.query_string.nil?
      parse_www_encoded_form(req.body) unless req.body.nil?
    end

    # Doesn't matter how the keys are stored, you should be able to get
    # them whether they are a string or a symbol.
    def [](key)
      @params[key.to_s] || @params[key.to_sym]
      # params[:id] => params['id']
    end

    # this will be useful if we want to `puts params` in the server log
    def to_s
      @params.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private
    # this should return deeply nested hash
    # argument format
    # user[address][street]=main&user[address][zip]=89436
    # should return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }

    # Example in pry
    # ary = URI.decode_www_form("a=1&a=2&b=3")
    # => [["a", "1"], ["a", "2"], ["b", "3"]]
    # query string = [[[user,fname], Jon], [[user, lname], Snow]]
    def parse_www_encoded_form(www_encoded_form)
      ary = URI.decode_www_form(www_encoded_form)
      ary.each do |pair|
        current = @params
        keys = parse_key(pair.first) # make an array of the keys
        keys.each do |key|
          # ||= to make sure we don't override previous user keys
          if key == keys.last
            current[key] = pair.last
          else
            current[key] ||= {}
            current = current[key]
          end
        end
      end
    end

    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
      key.split(/\]\[|\[|\]/)
    end
  end
end
