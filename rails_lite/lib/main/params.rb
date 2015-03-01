require 'uri'

class Params

  def initialize(req, route_params = {})
    @params = route_params
    if req.query_string
      parse_www_encoded_form(req.query_string).each do |hash|
        @params[hash.keys.first] = rec_add_hash(hash.values.first)
      end
    end
    if req.body
      parse_www_encoded_form(req.body).each do |hash|
        @params[hash.keys.first] = rec_add_hash(hash.values.first)
      end
    end
  end

  def rec_add_hash(maybe_hash)
    if maybe_hash.is_a?(Hash)
      temp_hash = {}
      maybe_hash.each do |key, val|
        temp_hash[key] = rec_add_hash(val)
      end
      temp_hash
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

  class AttributeNotFoundError < ArgumentError
  end

  private

  def parse_www_encoded_form(www_encoded_form)
    output = []
    URI::decode_www_form(www_encoded_form).each do |kv_pair|
      k, v = kv_pair
      key_seq = parse_key(k)
      temp_hash = { key_seq.last => v }
      key_seq.reverse.drop(1).each { |key| temp_hash = { key => temp_hash } }
      output << temp_hash
    end

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

    merged_output
  end

  def rec_merge(hash, other_hash)
    if hash.keys.first == other_hash.keys.first
      { hash.keys.first => rec_merge(hash.values.first, other_hash.values.first) }
    else
      { hash.keys.first => hash.values.first,
        other_hash.keys.first => other_hash.values.first }
    end
  end

  def parse_key(key)
    key.split(/\]\[|\[|\]/)
  end
end
