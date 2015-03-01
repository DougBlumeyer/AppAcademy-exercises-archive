def eval_block(*args, &prc)
  raise "NO BLOCK GIVEN!" unless block_given?
  prc.call(*args)
end
