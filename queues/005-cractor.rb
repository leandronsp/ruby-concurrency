class Cractor
  def initialize(state)
    @inbox  = Queue.new
    @outbox = Queue.new

    Thread.new do
      result = yield(@inbox, @outbox, state)

      @outbox.push(result)
    end
  end

  def inbox  = @inbox
  def outbox = @outbox
end

actor = Cractor.new(0) do |inbox, outbox, balance|
  loop do
    message = inbox.pop

    case message
    in increment: value then balance += value.to_i
    in decrement: value then balance -= value.to_i
    in get: :balance    then outbox.push(balance)
    end
  end
end

actor.inbox.push({ increment: 10 })
actor.inbox.push({ decrement: 5 })
actor.inbox.push({ get: :balance })

puts "Balance is #{actor.outbox.pop}"
