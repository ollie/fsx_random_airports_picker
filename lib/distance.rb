class Numeric
  def to_rad
    self * Math::PI / 180
  end
end

include Math

class Point
  attr_accessor :latitude, :longitude
  def lat; latitude; end
  def long; longitude; end

  def initialize
    yield self if block_given?
  end

  def latitude=(value)
    @latitude = value.to_f
  end

  def longitude=(value)
    @longitude = value.to_f
  end
end

class Distance
  R = 6371 # km
  NAUTICAL_MILE = 1.852 # km

  def self.calc(p1, p2)
    # a = sin²(Δlat/2) + cos(lat1).cos(lat2).sin²(Δlong/2)
    # c = 2.atan2(√a, √(1−a))
    # d = R.c
    # where R is earth’s radius (mean radius = 6 371 km);
    # note that angles need to be in radians to pass to trig functions!
    d_lat  = (p2.lat - p1.lat).to_rad
    d_long = (p2.long - p1.long).to_rad
    a      = sin(d_lat / 2) ** 2 + sin(d_long / 2) ** 2 * cos(p1.lat.to_rad) * cos(p2.lat.to_rad)
    c      = 2 * atan2( sqrt(a), sqrt(1 - a) )
    d      = (R * c / NAUTICAL_MILE).round
  end
end

# p1 = Point.new do |p|
#  p.latitude = 35.153708272
#  p.longitude = -87.056825012
# end

# p2 = Point.new do |p|
#  p.latitude = 47.508889027
#  p.longitude = 9.262777716
# end

# p Distance.calc p1, p2
