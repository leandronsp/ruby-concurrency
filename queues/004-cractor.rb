class Cractor
  def initialize(balance = 0)
    @inbox  = Queue.new
    @outbox = Queue.new

    Thread.new do
      loop do
        message = @inbox.pop

        case message
        in increment: value then balance += value.to_i
        in get: :balance    then @outbox.push(balance)
        end
      end
    end
  end

  def inbox = @inbox
  def outbox = @outbox
end

actor = Cractor.new(0)

actor.inbox.push({ increment: 10 })
actor.inbox.push({ get: :balance })

puts "Balance is #{actor.outbox.pop}"
