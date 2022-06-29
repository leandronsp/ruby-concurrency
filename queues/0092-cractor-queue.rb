require './lib/cractor'

@inbox = Cractor.new do |instance|
  loop do
    instance.outbox.push(instance.inbox.pop)
  end
end

@outbox = Cractor.new do |instance|
  loop do
    instance.outbox.push(instance.inbox.pop)
  end
end

## Actor ##
Thread.new do
  balance = 0

  loop do
    message = @inbox.pop

    case message
    in increment: value then balance += value.to_i
    in get: :balance    then @outbox.push(balance)
    end
  end
end

## Interacting with the Actor ##
@inbox.push({ increment: 10 })
@inbox.push({ get: :balance })

puts "Balance is: #{@outbox.pop}"
