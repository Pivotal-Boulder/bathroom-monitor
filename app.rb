require 'active_support'
require 'dino'
require 'yaml'
require './room_status'

board = Dino::Board.new(Dino::TxRx.new)

YAML.load(File.open(File.expand_path("../rooms.yml", __FILE__))).each do |room|
  room_status = RoomStatus.new(room["name"], room["post_url"])

  button = Dino::Components::Button.new(pin: room["pin"], board: board)
  button.down { room_status.busy! }
  button.up { room_status.free! }
end
sleep