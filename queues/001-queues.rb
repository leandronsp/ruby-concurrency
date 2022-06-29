puts "#### Queues are Arrays ####"
queue = Array.new

queue << 1
queue << 2
queue << 3

puts queue.shift
puts queue.shift
puts queue.shift
puts queue.shift # nil

puts "#### Simple Queue ####"

class MyQueue
  def initialize
    @queue = []
  end

  def push(element) = @queue << element
  def pop           = @queue.shift
end

queue = MyQueue.new

queue.push(1)
queue.push(2)
queue.push(3)

puts queue.pop
puts queue.pop
puts queue.pop
puts queue.pop
