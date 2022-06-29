class MyQueue
  def initialize
    @queue = []
  end

  def push(element)
    @queue << element
  end

  def pop
    @queue.shift
  end
end
