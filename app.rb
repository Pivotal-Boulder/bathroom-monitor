require 'sinatra'
require 'active_support'
require 'dino'

begin
  board = Dino::Board.new(Dino::TxRx.new)
  button = Dino::Components::Button.new(pin: 12, board: board)

  button.down { BathroomStatus.south.busy! }
  button.up { BathroomStatus.south.free! }
rescue Dino::BoardNotFound
  get '*' do
    "The board cannot be found"
  end
end

get '/bathroom-north.rss' do
  @bathroom_status = BathroomStatus.north
  erb :bathroom
end

get '/bathroom-south.rss' do
  @bathroom_status = BathroomStatus.south
  erb :bathroom
end

class BathroomStatus
  attr_reader :location, :status, :updated_at

  def self.north
    @north ||= self.new :north
  end

  def self.south
    @south ||= self.new :south
  end

  def title
    "#{location.capitalize} Bathroom"
  end

  def busy!
    self.status = :broken
    self.updated_at = Time.now
  end

  def free!
    self.status = :stable
    self.updated_at = Time.now
  end

  private

  attr_writer :location, :status, :updated_at

  def initialize(location = :north)
    self.location = location
    self.status = :stable
    self.free!
  end
end
