#
# Haversine formula to compute the great circle distance between two points given their latitude and longitudes
#
# Notes:
#
# translated into Ruby based on information contained in:
#   http://en.wikipedia.org/wiki/Haversine_formula
#
# This formula can compute accurate distances between two points given latitude and longitude, even for
# short distances.

require 'haversine/distance'

module Haversine

  RAD_PER_DEG = Math::PI / 180

  # given two lat/lon points, compute the distance between the two points using the haversine formula
  def self.distance(lat1, lon1, lat2=nil, lon2=nil)
    # Accept two arrays of points in addition to four coordinates
    if lat1.is_a?(Array) && lon1.is_a?(Array)
      lat2, lon2 = lon1
      lat1, lon1 = lat1
    elsif lat2.nil? || lon2.nil?
      raise ArgumentError
    end

    dlon = lon2 - lon1
    dlat = lat2 - lat1

    a = calc(dlat, lat1, lat2, dlon)
    c = 2 * Math.atan2( Math.sqrt(a), Math.sqrt(1-a))

    Haversine::Distance.new(c)
  end

  # TODO How can this be more descriptively named?
  def self.calc(dlat, lat1, lat2, dlon)
    (Math.sin(rpd(dlat)/2))**2 + Math.cos(rpd(lat1)) * Math.cos((rpd(lat2))) * (Math.sin(rpd(dlon)/2))**2
  end

  # Radians per degree
  def self.rpd(num)
    num * RAD_PER_DEG
  end
end