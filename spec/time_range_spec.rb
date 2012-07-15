require 'time_range'

describe TimeRange do
  describe 'instantiation' do
    context 'with two time objects' do
      specify do
        start  = Time.now
        finish = Time.now + 1

        TimeRange.new(start, finish).should be_a(TimeRange)
      end
    end
  end
end
