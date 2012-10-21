require_relative 'spec_helper'

describe TimeRange do
  let(:now) { Time.new(2012, 07, 16, 10, 00, 00) }
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

  describe '#==' do
    let(:start)  { Time.now }
    let(:finish) { Time.now + 1 }      

    specify do
      tr1 = TimeRange.new start, finish
      tr2 = TimeRange.new start, finish

      tr1.should == tr2
    end
  end

  describe 'overlap' do
    [
      %w(
        OO----
        ---OOO),
      %w(
        ---OOO
        OO----),
      %w(
        OO----
        --OOOO),
      %w(
        --OOOO
        OO----),
      %w(
        OOO---
        --OOOO
        --O---),
      %w(
        --OOOO
        OOO---
        --O---),
      %w(
        --O---
        --O---
        --O---)
    ].each do |bars|
      tr1, tr2, expected = bars.map {|bar| trp bar}

      specify "of #{bars[0..1].join(' and ')} == #{bars[2]}" do
        returned = tr1.overlap(tr2)
        if expected
          returned.should == expected
        else
          returned.should be_nil
        end
      end
    end
  end
end

# 01 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23
