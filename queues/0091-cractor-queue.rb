require './lib/cractor'

queue = Cractor.new do |instance|
  loop do
    instance.outbox.push(instance.inbox.pop)
  end
end

queue.push(1)
queue.push(2)
queue.push(3)

puts queue.pop
puts queue.pop
puts queue.pop
