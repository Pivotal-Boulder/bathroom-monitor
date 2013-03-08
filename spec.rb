require 'rspec'
require './app'

describe BathroomStatus do
  let (:north_status) { BathroomStatus.north }
  let (:south_status) { BathroomStatus.south }

  describe '.north' do
    it 'should return the same instance' do
      BathroomStatus.north.should be BathroomStatus.north
    end
  end

  describe '.south' do
    it 'should return the same instance' do
      BathroomStatus.south.should be BathroomStatus.south
    end
  end

  it 'should record its location' do
    north_status.location.should == :north
    south_status.location.should == :south
  end

  describe '#title' do
    it 'should include the location' do
      north_status.title.should == 'North Bathroom'
      south_status.title.should == 'South Bathroom'
    end
  end

  describe '#status' do
    it 'should default to "stable"' do
      north_status.status.should == :stable
    end
  end

  describe '#busy!' do
    it 'should set the status to :broken' do
      now = Time.now
      Time.stub(:now).and_return(now)

      north_status.busy!
      north_status.status.should == :broken
      north_status.updated_at.should == now
    end
  end

  describe '#free!' do
    it 'should set the status to :stable' do
      now = Time.now
      Time.stub(:now).and_return(now)

      north_status.free!
      north_status.status.should == :stable
      north_status.updated_at.should == now
    end
  end
end

describe Status do
  before do
    @status = Status.new
  end

  describe "#check" do
    describe "less then 30 items checked" do
      it "returns false" do
        29.times do |n|
          @status.check(n).should be false
        end
      end
    end

    describe "more then 30 items checked" do
      it "returns false if any of the last 30 are not 0" do
        30.times do
          @status.check(0)
        end
        @status.check(1).should be false
        @status.check(0).should be false
      end

      it "returns true if all of the last 30 are 0" do
        @status.check(1)

        29.times do
          @status.check(0)
        end

        @status.check(0).should be false
        @status.check(0).should be true
      end
    end
  end
end
