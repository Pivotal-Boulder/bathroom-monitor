require 'active_support'
require 'dino'
require 'fire/forget'
require './bathroom_status'

board = Dino::Board.new(Dino::TxRx.new)
button = Dino::Components::Button.new(pin: 12, board: board)

button.down { BathroomStatus.south.busy! }
button.up { BathroomStatus.south.free! }

sleep