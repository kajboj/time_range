require_relative 'time_range'

class TimeRangeParser
  def self.parse bar
    TimeRangeParser.new(bar).parse
  end

  def initialize bar
    @bar = bar
  end

  def parse
    return nil if empty?
  end

  private

  def empty?
    chars = @bar.to_s.split('').uniq
    chars.each do |c|
      return false unless empty_chars.include? c
    end
    true
  end

  def empty_chars
    [' ', '-']
  end
end
