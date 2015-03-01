class Array
  def my_dup
    duped_arr = []
    self.each do |el|
      el.is_a?(Array) ? duped_arr << el.my_dup : duped_arr << el
    end

    duped_arr
  end
end
