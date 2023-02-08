require './lib/synchronized-queue'
require './lib/my-queue'

puts "#### Actors do not share state ####"

#@inbox  = MyQueue.new
#@outbox = MyQueue.new

@inbox  = SynchronizedQueue.new
@outbox = SynchronizedQueue.new

#### Actor ####
actor = Thread.new do
  balance = 0 # <---- internal, only accessible within the thread

  loop do
    # bloquear até chegar mensagem na fila
    message = @inbox.pop # <----- messages arrive in the inbox

    case message
    in increment: value then balance += value.to_i
    in get: :balance    then @outbox.push(balance) # <---- responses are sent to the outbox
    end
  end
end

@inbox.push({ increment: 10 })
@inbox.push({ get: :balance })

balance = @outbox.pop
puts "Balance is: #{balance}"
