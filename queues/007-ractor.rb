class Account
  def initialize(balance = 0)
    @state = Ractor.new(0) do |balance|
      loop do
        message = Ractor.receive

        case message
        in increment: value then balance += value.to_i
        in get: :balance    then Ractor.yield(balance)
        end
      end
    end
  end

  def increment(value)
    @state.send({ increment: value })
  end

  def balance
    @state.send({ get: :balance })
    @state.take
  end
end

account = Account.new

account.increment(10)

puts "Balance is #{account.balance}"
