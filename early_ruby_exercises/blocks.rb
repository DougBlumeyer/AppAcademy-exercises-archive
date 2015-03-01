class Array

  def my_each(&prc)
    i = 0
    arr = []
    while i < self.length
      arr << prc.call(self[i])
      i += 1
    end
    self
  end

  def my_map(&prc)
    arr = []
    self.my_each { |x| arr << prc.call(x) }
    arr
  end

  def my_select(&prc)
    arr = []
    self.my_each { |x| arr << x if prc.call(x) }
    arr
  end

  def my_inject(&prc)
    acc = self.first
    self[1..-1].my_each { |x| acc = prc.call(acc, x) }
    acc
  end

  def my_sort!(&prc)
    sorted = false
    until sorted
      sorted = true
      i = 0
      while i < self.length - 1
        if prc.call(self[i], self[i+1]) == 1
          self[i], self[i+1] = self[i+1], self[i]
          sorted = false
        end
        i += 1
      end
    end
    self
  end

  def my_sort(&prc)
    arr = self.dup.my_sort!(&prc)
    arr 
  end

end
