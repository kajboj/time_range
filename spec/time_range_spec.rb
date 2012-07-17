require 'timecop'
require_relative '../time_range'

describe TimeRange do
  let(:now) { Time.local(2012, 07, 16, 10, 00, 00) }

  before(:each) do
    Timecop.freeze now
  end

  describe 'instantiation' do
    context 'with two time objects' do
      specify do
        start  = Time.now
        finish = Time.now + 1

        TimeRange.new(start, finish).should be_a(TimeRange)
      end
    end

    context 'with bar representing time range' do
      specify do
        TimeRange.new('-O-').should be_a(TimeRange)
      end
    end
  end
end
