class TimeRange
  def initialize *args
    case args.size
    when 2
      @start, @finish = args
    when 1
      @time_bar = args.first
    else
      raise "wrong number of arguments (#{args.size})"
    end
  end
end
