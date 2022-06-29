@inbox = Ractor.new do
  loop do
    Ractor.yield(Ractor.receive)
  end
end

@outbox = Ractor.new do
  loop do
    Ractor.yield(Ractor.receive)
  end
end

## Account Actor ##
Ractor.new(@inbox, @outbox) do |inbox, outbox|
  balance = 0

  loop do
    message = inbox.take

    case message
      in increment: value then balance += value.to_i
      in get: :balance    then outbox.send(balance)
    end
  end
end

@inbox.send({ increment: 10 })
@inbox.send({ get: :balance })

puts "Balance is: #{@outbox.take}"
