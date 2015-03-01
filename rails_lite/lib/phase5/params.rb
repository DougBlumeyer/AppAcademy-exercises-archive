require 'uri'

module Phase5
  class Params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    #
    # You haven't done routing yet; but assume route params will be
    # passed in as a hash to `Params.new` as below:
    def initialize(req, route_params = {})
      @params = route_params
      if req.query_string
        parse_www_encoded_form(req.query_string).each do |hash|
          @params[hash.keys.first] = rec_add_hash(hash.values.first)
        end
        #debugger
      end
      if req.body

        parse_www_encoded_form(req.body).each do |hash|
          @params[hash.keys.first] = rec_add_hash(hash.values.first)
        end
        #debugger
      end
    end

    def rec_add_hash(maybe_hash)
      if maybe_hash.is_a?(Hash)
        temp_hash = {}
        maybe_hash.each do |key, val|
          temp_hash[key] = rec_add_hash(val)
        end
        temp_hash
        #{ maybe_hash.keys.first => rec_add_hash(maybe_hash.values.first) }
      else
        maybe_hash
      end
    end

    def [](key)
      @params[key.to_s]
    end

    def to_s
      @params.to_json.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private
    # this should return deeply nested hash
    # argument format
    # user[address][street]=main&user[address][zip]=89436
    # should return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
    def parse_www_encoded_form(www_encoded_form)
      #nest_seq = parse_key(www_encoded_form)
      #debugger
      output = []
      #debugger
      URI::decode_www_form(www_encoded_form).each do |kv_pair|
        k, v = kv_pair
        key_seq = parse_key(k)
        temp_hash = { key_seq.last => v }
        #output[key_seq.last] = v
        key_seq.reverse.drop(1).each { |key| temp_hash = { key => temp_hash } }
        output << temp_hash
      end
      #debugger
      #output

      merge_connected_branches(output)
    end

    def merge_connected_branches(output)
      merged_output = output

      output.each_with_index do |hash, index|
        output[index + 1 .. -1].each do |other_hash|
          if hash.keys.first == other_hash.keys.first
            merged_output << { hash.keys.first => rec_merge(hash.values.first, other_hash.values.first) }
            merged_output.delete(hash)
            merged_output.delete(other_hash)
          end
        end
      end

      #puts "MERGED OUTPUT: #{merged_output}"
      merged_output
    end

    def rec_merge(hash, other_hash)
      #puts "hashYYYYY: #{hash}, #{other_hash}"
      if hash.keys.first == other_hash.keys.first
        #puts "equal"
        { hash.keys.first => rec_merge(hash.values.first, other_hash.values.first) }
      else
        #puts "unequal"
        { hash.keys.first => hash.values.first,
          other_hash.keys.first => other_hash.values.first }
      end
    end

    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
      key.split(/\]\[|\[|\]/)
    end
  end
end
