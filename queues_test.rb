require 'test/unit'

class Stack
  def initialize
    @array = []
  end

  def push(elem) = @array << elem
  def pop = @array.pop
  def size = @array.size
end

class LIFOQueue
  def initialize
    @stack = Stack.new
    @amortized = Stack.new
  end

  def enqueue(elem)
    @stack.push(elem)
  end

  def dequeue
    @amortized.push(@stack.pop) while @stack.size > 0
    @amortized.pop
  end
end

class QueuesTest < Test::Unit::TestCase
  def test_stack
    stack = Stack.new

    stack.push(1)
    stack.push(2)
    stack.push(3)

    assert_equal stack.pop, 3
    assert_equal stack.pop, 2
    assert_equal stack.pop, 1
    assert_equal stack.pop, nil
  end

  def test_lifo_queue
    queue = LIFOQueue.new

    queue.enqueue(1)
    queue.enqueue(2)
    queue.enqueue(3)

    assert_equal queue.dequeue, 1
    assert_equal queue.dequeue, 2
    assert_equal queue.dequeue, 3
    assert_equal queue.dequeue, nil
  end
end
