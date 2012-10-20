require_relative 'spec_helper'
require_relative '../time_range_parser'

describe 'TimeRangeParser.parse' do
  let(:now) { Time.new(2012, 07, 16, 10, 00, 00) }
  before(:each) { Timecop.freeze now }

  subject(:time_range) { TimeRangeParser.parse bar }

  context 'with valid timebar' do
    {
      'O'   => '16 00:00:00 - 17 00:00:00',
      '-O'  => '16 12:00:00 - 17 00:00:00',
      'O-'  => '16 00:00:00 - 16 12:00:00',
      'OO'  => '16 00:00:00 - 17 00:00:00',

      '-O-' => '16 08:00:00 - 16 16:00:00',
      'O--' => '16 00:00:00 - 16 08:00:00',
      '--O' => '16 16:00:00 - 17 00:00:00',
      'OO-' => '16 00:00:00 - 16 16:00:00',
      '-OO' => '16 08:00:00 - 17 00:00:00',
      'OOO' => '16 00:00:00 - 17 00:00:00',

      '--OO-' => '16 09:36:00 - 16 19:12:00',
      '- X? ' => '16 09:36:00 - 16 19:12:00',
    }.each do |timebar, range|
      start, finish = range.split('-').map(&:strip)
      context timebar do
        let(:bar) { timebar }

        it "is parsed to #{range}" do
          time_range.should == tr("2012-07-#{start}", "2012-07-#{finish}")
        end
      end
    end
  end

  context 'with empty timebar' do
    [nil, '', ' ', '-', '---'].each do |timebar|
      context timebar do
        let(:bar) { timebar }

        it { should be_nil }
      end
    end
  end

  context 'with invalid time bar' do
    [
      'O-O',
      'O-O-O',
      'i n- v- a li-d'
    ].each do |timebar|
      context timebar do
        let(:bar) { timebar }

        specify do
          lambda do
            subject
          end.should raise_error ArgumentError
        end
      end
    end
  end
end
