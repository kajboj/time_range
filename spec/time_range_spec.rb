require_relative 'spec_helper'

describe TimeRange do
  let(:now) { Time.local(2012, 07, 16, 10, 00, 00) }
  before(:each) { Timecop.freeze now }

  describe '.new' do
    context 'with two time objects' do
      subject { TimeRange.new start, finish }
      let(:start)  { Time.now }
      let(:finish) { Time.now + 1 }      

      it { should be_a(TimeRange) }
      its(:start)  { should == start }
      its(:finish) { should == finish }
    end

    context "with invalid arguments" do
      [ [], ['hello'], [Time.now]*3 ].each do |args|
        context "#{args.inspect}" do
          specify do
            lambda do
              TimeRange.new *args
            end.should raise_error ArgumentError
          end
        end
      end
    end
  end
end

# 01 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23
