require 'rspec'
require './room_status'
require 'fire/forget'

describe RoomStatus do
  let (:room) { RoomStatus.new("North Room", "some_url") }

  let(:failure_json) {
    {
      name: "North Room",
      url: "",
      build: {
        number: 20,
        phase: "FINISHED",
        status: "FAILURE",
        url: "/#{20}/"
      }
    }
  }

  let(:success_json) {
    {
      name: "North Room",
      url: "",
      build: {
        number: 20,
        phase: "FINISHED",
        status: "SUCCESS",
        url: "/#{20}/"
      }
    }
  }
  before do
    FAF.stub(:post)
  end

  describe '#busy!' do
    it 'should set the status to send broken json' do
      Time.should_receive(:now).and_return(20)
      FAF.should_receive(:post).with("some_url", failure_json, anything)
      room.busy!
    end
  end

  describe '#free!' do
    it 'should send the success json' do
      Time.should_receive(:now).and_return(20)
      FAF.should_receive(:post).with("some_url", success_json, anything)
      room.free!
    end
  end
end