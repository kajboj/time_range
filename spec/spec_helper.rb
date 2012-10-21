require 'timecop'
require_relative '../time_range'
require_relative '../time_range_parser'

def tr start_string, finish_string
  TimeRange.new(
    t(start_string),
    t(finish_string))
end

def t time_string
  DateTime.parse(time_string).to_time
end

def trp bar
  TimeRangeParser.parse bar
end
