require_relative 'spec_helper'
require_relative '../time_range_parser'

describe 'TimeRangeParser.parse' do
  let(:now) { Time.local(2012, 07, 16, 10, 00, 00) }
  before(:each) { Timecop.freeze now }

  subject(:time_range) { TimeRangeParser.parse bar }

  specify do
    tr("2012-07-16 08:00", "2012-07-16 16:00")
  end

  context 'with valid non empty timebar' do
    {
      '-O-' => '16 08:00 - 16 16:00',
      'O--' => '16 00:00 - 16 08:00',
      '--O' => '16 16:00 - 17 00:00',
      'OO-' => '16 00:00 - 16 16:00',
      '-OO' => '16 08:00 - 17 00:00',
      'OOO' => '16 00:00 - 17 00:00',

      '--O--' => '16 09:36 - 16 14:24',
    }.each do |timebar, range|
      start, finish = range.split('-').map(&:strip)
      context timebar do
        let(:bar) { timebar }

        it "is #{range} for today" do
          time_range.should == tr("2012-07-#{start}", "2012-07-#{finish}")
        end
      end
    end
  end

  context 'with empty timebar' do
    ['', ' ', '-', '---'].each do |timebar|
      let(:bar) { timebar }

      context timebar do
        it { should == nil }
      end
    end
  end

  context 'with invalid time bar' do
    let(:bar) { 'O-O' }

    specify do
      lambda do
        TimeRange.parse('O-O')
      end.should raise_error ArgumentError
    end
  end
end
