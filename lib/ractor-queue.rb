class RactorQueue
  def initialize
    @queue = Ractor.new do
      loop do
        Ractor.yield(Ractor.receive)
      end
    end
  end

  def push(element)
    @queue.send(element)
  end

  def pop
    @queue.take
  end
end
