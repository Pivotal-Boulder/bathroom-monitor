require 'rspec'
require './bathroom_status'
require 'fire/forget'

describe BathroomStatus do
  let (:north_status) { BathroomStatus.north }
  let (:south_status) { BathroomStatus.south }

  before do
    FAF.stub(:post)
  end

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
      north_status.status.should == "SUCCESS"
    end
  end

  describe '#busy!' do
    it 'should set the status to :broken' do
      now = Time.now
      Time.stub(:now).and_return(now)

      north_status.busy!
      north_status.status.should == "FAILURE"
    end
  end

  describe '#free!' do
    it 'should set the status to :stable' do
      now = Time.now
      Time.stub(:now).and_return(now)

      north_status.free!
      north_status.status.should == "SUCCESS"
    end
  end
end