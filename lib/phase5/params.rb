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
    def initialize(req, route_params = {})
      @params = {}
    end

    def [](key)
      @params[key.to_s]
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
    def parse_www_encoded_form(www_encoded_form)
      ary = URI.decode_www_form(www_encoded_form)
      ary.each do |sub_ary|
        key = sub_ary[0]
        value = sub_ary[1]
        @params[key] = value
      end
    end

    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
    end
  end
end
