require_relative 'time_range'

class TimeRangeParser
  class << self
    def parse bar
      TimeRangeParser.new(bar).parse
    end

    attr_writer :bar_range

    def bar_range
      @bar_range || default_bar_range
    end

    def default_bar_range
      TimeRange.new(
        default_bar_start, default_bar_finish)
    end

    def default_bar_start
      t = Time.now
      Time.new t.year, t.month, t.day, 0, 0, 0
    end

    def default_bar_finish
      default_bar_start + 24*60*60
    end
  end

  def initialize bar
    @bar = bar
  end

  def parse
    return nil if empty_bar?

    start, finish = start_and_finish

    validate_remainder finish

    indexes_to_time_range start, finish
  end

  private

  def validate_remainder finish
    remaining_chars = @bar[finish..-1].split('')

    remaining_chars.each do |c|
      raise ArgumentError.new("Invalid time bar #{@bar}") unless empty? c
    end
  end

  def indexes_to_time_range start_index, finish_index
    args = [start_index, finish_index].map do |index|
      bar_start + (index.to_f / length) * bar_length_in_seconds
    end

    TimeRange.new *args
  end

  def start_and_finish
    start = nil
    chars.each.with_index do |c, i|
      if empty? c
        return [start, i] if start
      else
        start ||= i
      end
    end
    [start, length]
  end

  def length
    @bar.length
  end

  def empty_bar?
    chars.uniq.each do |c|
      return false unless empty? c
    end
    true
  end

  def empty_chars
    [' ', '-']
  end

  def empty? char
    empty_chars.include? char
  end

  def chars
    @bar.to_s.split ''
  end

  def bar_length_in_seconds
    bar_finish - bar_start
  end

  def bar_start
    self.class.bar_range.start
  end

  def bar_finish
    self.class.bar_range.finish
  end
end
