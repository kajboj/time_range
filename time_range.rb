class TimeRange
  attr_reader :start, :finish

  def initialize *args
    if args.size == 2
      @start, @finish = args
    else
      raise ArgumentError, "wrong number of arguments (#{args.size})"
    end
  end

  def self.parse s
  end
end
