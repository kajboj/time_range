require 'pry'
require 'timecop'
require_relative '../time_range'

describe TimeRange do
  let(:now) { Time.local(2012, 07, 16, 10, 00, 00) }

  before(:each) do
    Timecop.freeze now
  end

  describe '.new' do
    subject { TimeRange.new *args }

    context 'with two time objects' do
      let(:args)   { [start, finish] }
      let(:start)  { Time.now }
      let(:finish) { Time.now + 1 }      

      it { should be_a(TimeRange) }
      its(:start)  { should == start }
      its(:finish) { should == finish }
    end

    [ [], ['hello'], [Time.now]*3 ].each do |args|
      context "with #{args.inspect}" do
        specify do
          lambda do
            TimeRange.new *args
          end.should raise_error ArgumentError
        end
      end
    end
  end

  describe '.parse' do
    subject(:time_range) { TimeRange.parse bar }

    context 'with timebar' do
      {
        '-O-' => '16 08:00 - 16 16:00',
        'O--' => '16 00:00 - 16 08:00',
        '--O' => '16 16:00 - 17 16:00',
        'OO-' => '16 00:00 - 16 16:00',
        '-OO' => '16 08:00 - 17 00:00',
        'OOO' => '16 00:00 - 17 00:00',

        '--O--' => '16 00:00 - 17 00:00',
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

    ['', ' ', '-', '---'].each do |timebar|
      let(:bar) { timebar }

      context timebar do
        it { should == nil }
      end
    end

    context 'O-O' do
      let(:bar) { 'O-O' }

      specify do
        lambda do
          TimeRange.parse('O-O')
        end.should raise_error ArgumentError
      end
    end
  end

  def tr start_string, finish_string
    TimeRange.new(
      t(start_string),
      t(finish_string))
  end

  def t time_string
    DateTime.parse(time_string).to_time
  end
end

# 01 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23
