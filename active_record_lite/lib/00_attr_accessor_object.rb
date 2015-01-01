class AttrAccessorObject
  def self.my_attr_accessor(*names)
    names.each do |name|
      instance_variable_set("@#{name}", nil)

      define_method("#{name}") do
        instance_variable_get("@#{name}")
      end

      define_method("#{name}=") do |set_to|
        instance_variable_set("@#{name}", set_to)
      end

    end
  end
end
