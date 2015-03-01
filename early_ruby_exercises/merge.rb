class Array
  def merge_sort(&prc)
    prc ||= proc { |num1, num2| num1 <=> num2 }
    if self.length == 0
      output = []
    elsif self.length == 1
      output = self
    else
      left = self[0...(self.length/2)].merge_sort(&prc)
      right = self[(self.length/2)..-1].merge_sort(&prc)
      output = merge(left,right,&prc)
    end
    output
  end

  def merge(left,right,&prc)
    output = []
    until left.empty? && right.empty?
      if left.empty?
        right.each { |el| output << el }
        right = []
      elsif right.empty?
        left.each { |el| output << el }
        left = []
      else
        if prc.call(left.first, right.first) == -1
          output << left.shift
        else
          output << right.shift
        end
      end
    end
    output
  end
end
