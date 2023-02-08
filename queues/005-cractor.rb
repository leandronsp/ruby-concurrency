class Cractor
  def initialize(state)
    @inbox  = Queue.new
    @outbox = Queue.new

    Thread.new do
      result = yield(self, state)

      @outbox.push(result)
    end

    self
  end

  def inbox  = @inbox
  def outbox = @outbox
end

state = Cractor.new(0) do |actor, balance|
  loop do
    message = actor.inbox.pop

    case message
    in increment: value then balance += value.to_i
    in decrement: value then balance -= value.to_i
    in get: :balance    then actor.outbox.push(balance)
    end
  end
end

state.inbox.push({ increment: 10 })
state.inbox.push({ decrement: 5 })
state.inbox.push({ get: :balance })

puts "Balance is #{state.outbox.pop}"
