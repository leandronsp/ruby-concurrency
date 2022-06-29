require './lib/synchronized-queue'

class Cractor
  def initialize(*args, &block)
    @inbox  = SynchronizedQueue.new
    @outbox = SynchronizedQueue.new

    Thread.new do
      result = block.call(self, *args)

      @outbox.push(result)
    end

    self
  end

  def push(value) = @inbox.push(value)
  def pop         = @outbox.pop

  def inbox = @inbox
  def outbox = @outbox
end
