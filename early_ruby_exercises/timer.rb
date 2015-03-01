def timer(&prc)
  start_timer = Time.now
  yield
  end_timer = Time.now
  end_timer - start_timer
end
