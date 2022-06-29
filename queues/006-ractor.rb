@balance = 0

account = Ractor.new(@balance) do |balance|
  loop do
    message = Ractor.receive # inbox.pop

    case message
    in increment: value then balance += value.to_i
    in get: :balance    then Ractor.yield(balance) # outbox.push
    end
  end
end

account.send({ increment: 10 })
account.send({ get: :balance })

puts "Balance is #{account.take}"
