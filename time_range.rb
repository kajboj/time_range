class TimeRange
  attr_reader :start, :finish

  def initialize *args
    if args.size == 2
      @start, @finish = args
    else
      raise ArgumentError, "wrong number of arguments (#{args.size})"
    end
  end

  def ==(o)
    start == o.start && finish == o.finish
  end
end
