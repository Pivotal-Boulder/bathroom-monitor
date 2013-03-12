require 'fire/forget'

class RoomStatus
  def initialize(name, post_url)
    self.name = name
    self.post_url = post_url
  end

  def busy!
    self.status = "FAILURE"
    self.build_id = Time.now.to_i
    FAF.post(post_url, build_json, {"X-Header" => true}) { |socket| socket.gets }
  end

  def free!
    self.status = "SUCCESS"
    self.build_id = Time.now.to_i

    FAF.post(post_url, build_json, {"X-Header" => true}) { |socket| socket.gets }
  end

  private
  attr_accessor :status, :build_id, :name, :post_url

  def build_json
    {name: name,
     url: "",
     build: {
       number: build_id,
       phase: "FINISHED",
       status: status,
       url: "/#{build_id}/"
     }
    }
  end
end