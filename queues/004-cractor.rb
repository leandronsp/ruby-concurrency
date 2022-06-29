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

    self
  end

  def inbox = @inbox
  def outbox = @outbox
end

state = Cractor.new(0)

state.inbox.push({ increment: 10 })
state.inbox.push({ get: :balance })

puts "Balance is #{state.outbox.pop}"
