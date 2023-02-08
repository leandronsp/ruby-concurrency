require './lib/synchronized-queue'

class Cractor
  def initialize(*args, &block)
    @inbox  = SynchronizedQueue.new
    @outbox = SynchronizedQueue.new

    Thread.new do
      result = block.call(@inbox, @outbox, *args)

      @outbox.push(result)
    end
  end

  def push(value) = @inbox.push(value)
  def pop         = @outbox.pop

  def inbox = @inbox
  def outbox = @outbox
end
