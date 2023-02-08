require './lib/cractor'

class CractorQueue
  def initialize
    @queue = Cractor.new do |inbox, outbox|
      loop do
        outbox.push(inbox.pop)
      end
    end
  end

  def push(element)
    @queue.push(element)
  end

  def pop
    @queue.pop
  end
end
