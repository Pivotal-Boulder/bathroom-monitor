require 'sinatra'
require 'active_support'
require 'dino'

get '/bathroom-north.rss' do
  @bathroom_status = BathroomStatus.north
  erb :bathroom
end

get '/bathroom-south.rss' do
  @bathroom_status = BathroomStatus.south
  erb :bathroom
end

class Status
  def initialize
    @queue = []
  end

  def check(status)
    add(status)
    @queue.length > 29 && @queue.all? { |status| status.to_i == 0 }
  end

  private
  def add(status)
    @queue.shift if @queue.length > 30
    @queue.push(status)
  end
end

board = Dino::Board.new(Dino::TxRx.new)
sensor = Dino::Components::Sensor.new(pin: 'A0', board: board)
status = Status.new

on_data = Proc.new do |data|
  status.add(data)
  status.zero? ? BathroomStatus.south.busy! : BathroomStatus.south.free!
end

sensor.when_data_received(on_data)

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
  end
end
