require 'uri'

class Params
  attr_accessor :params

  # Initialize merges params from query string, post body and route
  # Route params will be passed in as a hash
  def initialize(req, route_params = {})
    @params = {}

    @params.merge!(route_params)

    if req.body
      @params.merge!(parse_www_encoded_form(req.body))
    end

    if req.query_string
      @params.merge!(parse_www_encoded_form(req.query_string))
    end
  end

  # Allows to address keys by string or symbol
  def [](key)
    @params[key.to_s] || @params[key.to_sym]
  end

  # Used to puts params in server log
  def to_s
    @params.to_s
  end

  class AttributeNotFoundError < ArgumentError; end;

  private
  
  # This should return a deeply nested hash
  def parse_www_encoded_form(www_encoded_form)
    params = {}

    key_values = URI.decode_www_form(www_encoded_form)
    key_values.each do |full_key, value|
      scope = params

      key_seq = parse_key(full_key)
      key_seq.each_with_index do |key, idx|
        if (idx + 1) == key_seq.count
          scope[key] = value
        else
          # || To prevent overriding previous key
          scope[key] ||= {}
          scope = scope[key]
        end
      end
    end

    params
  end

  # User[address][zipcode] should return ['user', 'address', 'zipcode']
  def parse_key(key)
    key.split(/\]\[|\[|\]/)
  end
end
