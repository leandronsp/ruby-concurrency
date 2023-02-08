require 'test/unit'

class Calc
  def self.sum(a, b) = a + b
end

class CalcTest < Test::Unit::TestCase
  def test_sum
    assert_equal Calc.sum(1, 1), 2
  end
end

task :calc do
  puts Calc.sum(1, 1)
end
