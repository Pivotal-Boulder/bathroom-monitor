class BathroomStatus
  WEBHOOKSURL = "http://projectmonitor.sf.pivotallabs.com/projects/c3de2dcf-f93b-4ade-9870-344cb989469d/status"

  attr_reader :location, :status, :build_id

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
    self.status = "FAILURE"
    self.build_id = Time.now.to_i

    FAF.post(WEBHOOKSURL, build_json, {"X-Header" => true}) { sleep(0.1) }
  end

  def free!
    self.status = "SUCCESS"
    self.build_id = Time.now.to_i

    FAF.post(WEBHOOKSURL, build_json, {"X-Header" => true}) { sleep(0.1) }
  end

  private

  attr_writer :location, :status, :build_id

  def initialize(location = :north)
    self.location = location
    self.status = :stable
    self.free!
  end

  def build_json
    {name: "Bathroom #{location.capitalize}",
     url: "job/bathroom-south/",
     build: {
       number: build_id,
       phase: "FINISHED",
       status: status,
       url: "job/bathroom-south/#{build_id}/"
     }
    }
  end
end