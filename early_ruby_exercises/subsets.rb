def subsets(set)
  if set.empty?
    subset_results = [[]]
  else
    subset_results = subsets(set.drop(1))
    new_subsets = []
    subset_results.each do |subset|
      new_subsets << subset + [set.first]
    end
    subset_results += new_subsets
  end

  subset_results
end
